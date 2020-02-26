class MiReportsController < ApplicationController
  before_filter :authenticate_user!

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

        if YieldFile.exists?(file_name: filename)
          duplicated_files << file
          respond_to do |format|
            format.json { render json: {error: filename + ' 發現重複匯入，已被略過！'} }
          end
          next
        else
          model_stage = 'BFIAMU'
          if post = Post.find_by_title(model_stage)
            MiReport.import_data(file.path, filename, post)
            # Check total imported row counts
            if file = YieldFile.find_by_file_name(filename)
              count = Report.where(post_id: post, yield_file_id: file).count

              # Check if CSV row numbers equal to record numbers that imported to database
              count + 7 == file.total_row
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
