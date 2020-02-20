class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def autocomplete_station_name
    post_id = params[:my_post_id]
    term = params[:term]
    stations = Station.where('post_id = ? AND name LIKE ?', post_id, "%#{term}%").order(:name).all
    render :json => stations.map { |s| {:id => s.id, :label => s.name, :value => s.name} }
  end

  def autocomplete_report_config
    post_id = params[:my_post_id]
    term = params[:term]
    reports = Report.where('post_id = ? AND config LIKE ?', post_id, "%#{term}%").select("distinct(config)").order(:config).limit(10)
    render :json => reports.map { |r| {:id => r.id, :label => r.config, :value => r.config} }
  end

  # Navbar Global Search Box

  def autocomplete_station
    term = params[:term]
    stations = Station.where('name LIKE ?', "%#{term}%").select("distinct(name)").order(:name).limit(10)
    render :json => stations.map { |s| {:id => s.id, :label => s.name, :value => s.name} }
  end

  def autocomplete_config
    term = params[:term]
    reports = Report.where('config LIKE ?', "%#{term}%").select("distinct(config)").order(:config).limit(10)
    render :json => reports.map { |r| {:id => r.id, :label => r.config, :value => r.config} }
  end

  def search
    @posts = Post.find(:all)
    @post = Post.find(params[:my_post_id]) if params[:my_post_id]
    @station = @post.stations.find_by_name(params[:station]) if params[:station]
    page = (params[:page] || 1).to_i

    # For rendering contents by click tab after search
    if params[:from_station]
      @station = @post.stations.find(params[:from_station])
      reports_by_all_config = @station.reports.where(config: 'ALL')
    elsif params[:from_report] && params[:show_config] == 'all'
      # Get all configs of station at specific datetime
      @report = @post.reports.find(params[:from_report])
      @station = @report.station
      @reports_for_cart = @post.reports.where('config != ? AND station_name = ? AND published_at = ?', 
        'ALL', @report.station_name, @report.published_at).order("published_at DESC")
      @reports = @reports_for_cart.page(page)
    else
      if params[:my_post_id]
        reports_by_all_config = @post.reports.where(config: 'ALL')
      end
    end

    if params[:date].present? && params[:date] == 'today'
      if @post.reports.count == 0
        redirect_to my_post_path(@post), alert: "No data found :("
        return
      else
        redirect_to my_post_path(@post)
      end
    elsif params[:date].present? && params[:date] == 'yesterday'
      if @post.reports.count == 0
        redirect_to my_post_path(@post), alert: "No data found :("
        return
      else
        redirect_to my_post_path(@post)
      end
    elsif params[:commit] == 'Search' || params[:commit] == 'GlobalSearch'
      # For search function
      station = params[:station]
      date_from = params[:date_range][0, 10] if params[:date_range]
      date_to = params[:date_range][13, 10] if params[:date_range]
      fix_datetime = params[:no_date_range] if params[:no_date_range]

      date1 = params[:date1] if params[:date1]
      date2 = params[:date2] if params[:date2]
      date3 = params[:date3] if params[:date3]

      t = Report.arel_table
      @reports_for_cart = Report.where(post_id: @post)
      @reports_for_cart = @reports_for_cart.where(t[:station_name].matches("#{station}")) if station.present?

      # Multiple Date Search
      if date1.present? || date2.present? || date3.present?
        dates_for_filter = []
        [date1, date2, date3].each do |date|
          dates_for_filter << date if date.present?
        end
        @reports_for_cart = @reports_for_cart.where(published_at: [dates_for_filter])
        @dates_selected = @reports_for_cart.select("distinct(published_at)")
        @dates_selected_count = @dates_selected.count

      # Date Range Search
      elsif date_from.present? && date_to.present?
        if date_from != date_to # Search for multiple days (ex. Jun 20 ~ Jun 23)
          # If search station, show data with each hour
          if params[:station].present? && params[:station] != "" && params[:data_period].present? && params[:data_period] == "hourly"
            @reports_for_cart = @reports_for_cart.where("(p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?) OR ((p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?)) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?)", 
              "#{date_from.to_date.year}", "#{date_from.to_date.month}", "#{date_from.to_date.day}", 6, 
              "#{date_from.to_date.tomorrow.year}", "#{date_to.to_date.year}", "#{date_from.to_date.tomorrow.month}", "#{date_to.to_date.month}", "#{date_from.to_date.tomorrow.day}", "#{date_to.to_date.day}", 
              "#{date_to.to_date.tomorrow.year}", "#{date_to.to_date.tomorrow.month}", "#{date_to.to_date.tomorrow.day}", 6)
          else
            # Search build, show data with only latest hour in each day
            @reports_for_cart = @reports_for_cart.where("( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) AND (p_hour >= ?) ) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) AND (p_hour < ?) )", 
              "#{date_from.to_date.year}", "#{date_to.to_date.year}", "#{date_from.to_date.month}", "#{date_to.to_date.month}", "#{date_from.to_date.day}", "#{date_to.to_date.day}", 6, 
              "#{date_from.to_date.tomorrow.year}", "#{date_to.to_date.tomorrow.year}", "#{date_from.to_date.tomorrow.month}", "#{date_to.to_date.month}", "#{date_from.to_date.tomorrow.day}", "#{date_to.to_date.tomorrow.day}", 6)
            # Define the date range for search feature
            search_date_range = ("#{date_from}".."#{date_to}")
            search_date_range.each do |the_date|
              date_range_index = search_date_range.find_index(the_date)
              #first_timestamp_of_date = @reports_for_cart.group(["p_year", "p_month", "p_mday"]).select("p_year, p_month, p_mday, Max(p_hour) as latest_hour").first
              #puts first_timestamp_of_date.p_mday.to_s
              record_of_midnight = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?", the_date.to_date.tomorrow.year, the_date.to_date.tomorrow.month, the_date.to_date.tomorrow.day, 6).first
              latest_hour_of_tomorrow = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour > ?", the_date.to_date.tomorrow.year, the_date.to_date.tomorrow.month, the_date.to_date.tomorrow.day, 6).order("published_at DESC").first
              latest_hour_of_today = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour > ?", the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, 6).order("published_at DESC").first
              latest_hour_of_yesterday = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", the_date.to_date.yesterday.year, the_date.to_date.yesterday.month, the_date.to_date.yesterday.day, 6).order("published_at DESC").first
              first_timestamp_of_date = @reports_for_cart.group(["p_year", "p_month", "p_mday"]).select("p_year, p_month, p_mday, Max(p_hour) as latest_hour").first
              last_timestamp_of_date = @reports_for_cart.group(["p_year", "p_month", "p_mday"]).select("p_year, p_month, p_mday, Max(p_mday) as last_day").order("p_mday DESC").first
              # Check if tomorrow of the_date has data with (hour < 6) for the_date.to_date
              if !record_of_midnight.nil?
                if !latest_hour_of_tomorrow.nil?
                  # Both record_of_midnight and latest_hour_of_tomorrow for the_date are found
                  if !latest_hour_of_yesterday.nil?
                    @reports_for_cart = @reports_for_cart.where("( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) ) OR (p_year = ? AND p_month = ? AND p_mday = ? AND (p_hour = ? OR p_hour = ?) ) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?))", 
                      the_date.to_date.tomorrow.tomorrow.year, search_date_range.last.to_date.tomorrow.year, the_date.to_date.tomorrow.tomorrow.month, search_date_range.last.to_date.tomorrow.month, the_date.to_date.tomorrow.tomorrow.day, search_date_range.last.to_date.tomorrow.day, 
                      the_date.to_date.tomorrow.year, the_date.to_date.tomorrow.month, the_date.to_date.tomorrow.day, record_of_midnight.p_hour, latest_hour_of_tomorrow.p_hour, 
                      the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, 6, 
                      search_date_range.first.to_date.year, the_date.to_date.yesterday.year, search_date_range.first.to_date.month, the_date.to_date.yesterday.month, search_date_range.first.to_date.day, the_date.to_date.yesterday.day)
                  else
                    @reports_for_cart = @reports_for_cart.where("( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) ) OR (p_year = ? AND p_month = ? AND p_mday = ? AND (p_hour = ? OR p_hour = ?) ) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?))", 
                      the_date.to_date.tomorrow.tomorrow.year, search_date_range.last.to_date.tomorrow.year, the_date.to_date.tomorrow.tomorrow.month, search_date_range.last.to_date.tomorrow.month, the_date.to_date.tomorrow.tomorrow.day, search_date_range.last.to_date.tomorrow.day, 
                      the_date.to_date.tomorrow.year, the_date.to_date.tomorrow.month, the_date.to_date.tomorrow.day, record_of_midnight.p_hour, latest_hour_of_tomorrow.p_hour, 
                      the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, 6, 
                      search_date_range.first.to_date.year, the_date.to_date.yesterday.year, search_date_range.first.to_date.month, the_date.to_date.yesterday.month, search_date_range.first.to_date.day, the_date.to_date.yesterday.day)
                  end
                else
                  # latest_hour_of_tomorrow for the_date is not found
                  @reports_for_cart = @reports_for_cart.where("( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) ) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?)", 
                    search_date_range.first.to_date.year, the_date.to_date.yesterday.year, search_date_range.first.to_date.month, the_date.to_date.yesterday.month, search_date_range.first.to_date.day, the_date.to_date.yesterday.day,
                    the_date.to_date.tomorrow.year, the_date.to_date.tomorrow.month, the_date.to_date.tomorrow.day, record_of_midnight.p_hour,
                    the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, 6)
                end
              else
                # Check if there is latest hour (hour > 6) exist for the_date
                if !latest_hour_of_today.nil?
                  #if search_date_range.find_index(the_date).equal? 0
                  if first_timestamp_of_date.p_mday.equal? the_date.to_date.day
                    if !search_date_range.find_index(the_date).equal? 0
                      @reports_for_cart = @reports_for_cart.where("(p_year = ? AND p_month = ? AND p_mday = ? AND (p_hour < ? OR p_hour = ?)) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) ) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) )", 
                        the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, 6, latest_hour_of_today.p_hour, 
                        the_date.to_date.tomorrow.year, search_date_range.last.to_date.tomorrow.year, the_date.to_date.tomorrow.month, search_date_range.last.to_date.tomorrow.month, the_date.to_date.tomorrow.day, search_date_range.last.to_date.tomorrow.day, 
                        search_date_range.first.to_date.year, the_date.to_date.yesterday.year, search_date_range.first.to_date.month, the_date.to_date.yesterday.month, search_date_range.first.to_date.day, the_date.to_date.yesterday.day)
                    else
                      @reports_for_cart = @reports_for_cart.where("( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) ) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) )", 
                        the_date.to_date.tomorrow.year, search_date_range.last.to_date.tomorrow.year, the_date.to_date.tomorrow.month, search_date_range.last.to_date.tomorrow.month, the_date.to_date.tomorrow.day, search_date_range.last.to_date.tomorrow.day, 
                        the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, latest_hour_of_today.p_hour, 
                        search_date_range.first.to_date.year, the_date.to_date.yesterday.year, search_date_range.first.to_date.month, the_date.to_date.yesterday.month, search_date_range.first.to_date.day, the_date.to_date.yesterday.day)
                    end
                  elsif search_date_range.find_index(the_date).between? 1, search_date_range.count - 2
                    @reports_for_cart = @reports_for_cart.where("( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) ) OR (p_year = ? AND p_month = ? AND p_mday = ? AND (p_hour < ? OR p_hour = ?)) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) )", 
                      the_date.to_date.tomorrow.year, search_date_range.last.to_date.tomorrow.year, the_date.to_date.tomorrow.month, search_date_range.last.to_date.tomorrow.month, the_date.to_date.tomorrow.day, search_date_range.last.to_date.tomorrow.day, 
                      the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, 6, latest_hour_of_today.p_hour, 
                      search_date_range.first.to_date.year, the_date.to_date.yesterday.year, search_date_range.first.to_date.month, the_date.to_date.yesterday.month, search_date_range.first.to_date.day, the_date.to_date.yesterday.day)
                  elsif last_timestamp_of_date.p_mday.equal? the_date.to_date.day
                    @reports_for_cart = @reports_for_cart.where("(p_year = ? AND p_month = ? AND p_mday = ? AND (p_hour = ? OR p_hour < ?)) OR ( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) )", 
                      the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, latest_hour_of_today.p_hour, 6, 
                      search_date_range.first.to_date.year, the_date.to_date.yesterday.year, search_date_range.first.to_date.month, the_date.to_date.yesterday.month, search_date_range.first.to_date.day, the_date.to_date.yesterday.day)
                  end
                end
              end
              # After handling last datetime timestamp (search_date_range.last), check if 2nd date of timestamp has midnight hour (hour < 6), if yes then delete all records of 1st date of timestamp
              if (search_date_range.find_index(the_date).equal? search_date_range.count - 1) && record_of_midnight.nil?
                #latest_hour_of_first_date = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", search_date_range.first.to_date.year, search_date_range.first.to_date.month, search_date_range.first.to_date.day, 6).first
                midnight_hour_of_second_date = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?", search_date_range.first.to_date.tomorrow.year, search_date_range.first.to_date.tomorrow.month, search_date_range.first.to_date.tomorrow.day, 6).first
                if !midnight_hour_of_second_date.nil?
                  @reports_for_cart = @reports_for_cart.where("( (p_year BETWEEN ? AND ?) AND (p_month BETWEEN ? AND ?) AND (p_mday BETWEEN ? AND ?) )", 
                    search_date_range.first.to_date.tomorrow.year, search_date_range.last.to_date.year, search_date_range.first.to_date.tomorrow.month, search_date_range.last.to_date.month, search_date_range.first.to_date.tomorrow.day, search_date_range.last.to_date.day)
                end
              end
            end
          end
        else
          the_date = "#{date_from}"
          record_of_midnight = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?", the_date.to_date.tomorrow.year, the_date.to_date.tomorrow.month, the_date.to_date.tomorrow.day, 6).first
          if !record_of_midnight.nil?
            @reports_for_cart = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?", 
              the_date.to_date.tomorrow.year, the_date.to_date.tomorrow.month, the_date.to_date.tomorrow.day, record_of_midnight.p_hour)
          else
            latest_hour_of_today = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, 6).order("published_at DESC").first
            @reports_for_cart = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?", 
              the_date.to_date.year, the_date.to_date.month, the_date.to_date.day, latest_hour_of_today.p_hour)
          end
          #@reports_for_cart = @reports_for_cart.where("(p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour < ?)", 
          #  "#{date_from.to_date.year}", "#{date_from.to_date.month}", "#{date_from.to_date.day}", 6, 
          #  "#{date_from.to_date.tomorrow.year}", "#{date_from.to_date.tomorrow.month}", "#{date_from.to_date.tomorrow.day}", 6)
          if params[:station] == ""
            latest_date = @reports_for_cart.maximum('published_at')
            @reports_for_cart = @reports_for_cart.where(published_at: latest_date)
          end
        end
      end

      if fix_datetime.present?
        # Search config at specific datetime
        @reports_for_cart = @reports_for_cart.where("p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?", 
          fix_datetime.to_datetime.year, fix_datetime.to_datetime.month, fix_datetime.to_datetime.day, fix_datetime.to_datetime.hour)
      end
      report_for_tmp = @reports_for_cart
      @reports_for_cart = report_for_tmp.order("published_at ASC")
      @distinct_date = @reports_for_cart.select("distinct(published_at)")
      
      @reports = report_for_tmp.order("station_id ASC, published_at ASC").page(page)
      @reports_summarize = @reports_for_cart.group_by(&:station_name)
    end
  end

  def show
    @post = Post.find(params[:my_post_id])
    @report = @post.reports.find(params[:id])
  end
  
  def create
    if request.post? && params[:file].present?
      csv_files = params[:file]
      imported_files = []
      duplicated_files = []
      filtered_files = []
      no_row_files = []

      csv_files.each do |file|
        # Prevent duplicated importing file
        filename = sanitize_filename(file.original_filename)
        line_count = `wc -l "#{file.path}"`.strip.split(' ')[0].to_i - 1

        puts line_count

        if YieldFile.exists?(file_name: filename)
          duplicated_files << file
          respond_to do |format|
            format.json { render json: {error: filename + ' 發現重複匯入，已被略過！'} }
          end
          next
        elsif line_count.equal? 0
          no_row_files << file
          respond_to do |format|
            format.json { render json: { error: filename + '沒有資料，已被略過！' } }
          end
          next
        else
          model_stage = 'BFIAMU'
          if post = Post.find_by_title(model_stage)
            Report.import_data(file.path, filename, post)
            # Check total imported row counts
            if file = YieldFile.find_by_file_name(filename)
              count = Report.where(post_id: post, yield_file_id: file).count

              puts count
              # Check if CSV row numbers equal to record numbers that imported to database
              if count + 4 == file.total_row
                imported_files << file
                respond_to do |format|
                  format.json { head :no_content }
                end
              else
                # If row counts are not equal, rollback all the imported rows
                file.destroy
                respond_to do |format|
                  format.json { render json: { error: '從 ' + filename + ' 匯入資料時發生錯誤！' } }
                end
              end
            end
          else
            post = Post.create(title: model_stage)
            # Then import yield records
            Report.import_data(file.path, filename, post)
            # Check total imported row counts
            if file = YieldFile.find_by_file_name(filename)
              count = Report.where(post_id: post, yield_file_id: file).count
              # Check if CSV row numbers equal to record numbers that imported to database
              if count.equal? file.total_row
                imported_files << file
                respond_to do |format|
                  format.json { head :no_content }
                end
              else
                # If row counts are not equal, rollback all the imported rows
                file.destroy
                respond_to do |format|
                  format.json { render json: { error: '從 ' + filename + ' 匯入資料時發生錯誤！' } }
                end
              end
            end
          end
        end
      end
    end
  end

  private

  def sanitize_filename(filename)
    return filename.strip do |name|
     # NOTE: File.basename doesn't work right with Windows paths on Unix
     # get only the filename, not the whole path
     name.gsub!(/^.*(\\|\/)/, '')
     # Strip out the non-ascii character
     name.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end
  end
end