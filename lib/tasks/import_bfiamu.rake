require 'csv'
require 'fileutils'

desc "This task is for importing BFIAMU csv files into database"
task :import_bfiamu, [:filename] => :environment do
	puts "Fetching csv files from folder..."
	imported_files = []
	imported_main_files = []
	imported_mini_files = []
    duplicated_files = []
	filtered_csvs_from_today = []
    no_row_files = []
    filtered_csvs = []
    check_filename_date = []
    target_folder = Dir.home + '/bfiamu_csv'
    # Define the folder of CSV files
	d = Dir.new(target_folder)
	#Dir.chdir(d)
	# This will recursively find all csv files in a given directory
	#csvs = d.entries.select {|csv| /^.+\.csv$/.match(csv)}
	filtered_csvs = Dir[ File.join(d, '**', '*.csv') ].reject { |p| File.directory? p }

	start_time = Time.now
	puts "Start importing BFIAMU data at #{start_time}"
	puts '-' * 50

	#Only import today's CSV files
	date_today = DateTime.parse(Date.today.to_s).strftime('%Y%m%d')
	date_yesterday = DateTime.parse((Date.today-1).to_s).strftime('%Y%m%d')
		
	# Get latest datetime stamp from csv filename lists
	filtered_csvs.select do |file|
		filename = File.basename(file).gsub('_', '-')
		file_date = filename[0, 8]
		check_filename_date << file_date
	end
	latest_date = check_filename_date.max #ex: 20200211, This is maybe Today or Yesterday

	# For the first time import, comment out below section of codes
	# filtered_csvs.select do |file|
	# 	filename = File.basename(file).gsub('_', '-')
	# 	if filename.eql? latest_date
	# 		filtered_csvs_from_today << file
	# 	end
	# end

	filtered_csvs.select do |file|
		filename = File.basename(file).gsub('_', '-')
		# line_count = `wc -l "#{file}"`.strip.split(' ')[0].to_i - 1
        # Check if csv file already existed (imported) in database
        if YieldFile.exists?(file_name: filename)
        	duplicated_files << file
        	puts filename.to_s + ' [Duplicated import]'
        	next
        # Do nothing when CSV files contain no row data
        # elsif line_count.equal? 0
        # 	no_row_files << file
        # 	next
        else # Process the CSV files that we actually need
        	model_stage = 'BFIAMU'
        	if post = Post.find_by_title(model_stage)
        		Report.import_data(file, filename, post)
        		# Check total imported row counts
        		if file = YieldFile.find_by_file_name(filename)
        			count = Report.where(post_id: post, yield_file_id: file).count
        			# Check if CSV row numbers equal to record numbers that imported to database
        			if count + 4 == file.total_row
		                imported_files << file
		                puts filename.to_s + ' [successfully imported]'
		            else
		                # If row counts are not equal, rollback all the imported rows
		                file.destroy
		                puts 'Data lost while importing data from ' + filename.to_s
		            end
		        end
		    else
		    	post = Post.create(title: model_stage)
	            # Then import yield records
	            Report.import_data(file, filename, post)
	            # Check total imported row counts
	            if file = YieldFile.find_by_file_name(filename)
	            	count = Report.where(post_id: post, yield_file_id: file).count
	            	# Check if CSV row numbers equal to record numbers that imported to database
	            	if count.equal? file.total_row
	            		imported_files << file
	            		puts filename.to_s + ' successfully imported!'
	            	else
	            		# If row counts are not equal, rollback all the imported rows
	            		file.destroy
	            		puts 'Data lost while importing ' + filename.to_s
	            	end
	            end
        	end
        end
	end
	puts '-' * 50
	puts filtered_csvs.count.to_s + ' CSV files processed, ' + duplicated_files.count.to_s + ' duplicated, ' + no_row_files.count.to_s + ' no row files, and ' + (imported_files.count + imported_main_files.count + imported_mini_files.count).to_s + ' files imported!'
	puts 'Auto importing process completed at ' + Time.now.to_s
	end_time = Time.now
	puts "Time elapsed #{(end_time - start_time)} seconds"
end