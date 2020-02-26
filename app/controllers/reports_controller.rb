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
    @station = @post.stations.find_by_id(params[:station]["id"]) if params[:station]
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

      date = params[:date] if params[:date]
      date1 = params[:date1] if params[:date1]
      date2 = params[:date2] if params[:date2]
      date3 = params[:date3] if params[:date3]
      search_type = params[:search_type] if params[:search_type]

      t = Report.arel_table
      @reports_for_cart = Report.where(post_id: @post)
      @reports_for_cart = @reports_for_cart.where(t[:station_name].matches("#{station}")) if station.present?

      # Multiple Date Search
      if date1.present? || date2.present? || date3.present? && !search_type.present?
        dates_for_filter = []
        [date1, date2, date3].each do |date|
          dates_for_filter << date if date.present?
        end
        @reports_for_cart = @reports_for_cart.where(published_at: [dates_for_filter])
        @dates_selected = @reports_for_cart.select("distinct(published_at)")
        @dates_selected_count = @dates_selected.count

        report_for_tmp = @reports_for_cart
        @reports_for_cart = report_for_tmp.order("published_at ASC")
        @distinct_date = @reports_for_cart.select("distinct(published_at)")
        
        @reports = report_for_tmp.order("station_id ASC, published_at ASC").page(page)
        @reports_summarize = @reports_for_cart.group_by(&:station_name)
      # Date Range Search
      elsif date_from.present? && date_to.present? && search_type.present? && search_type == "Range"
        if date_from != date_to # Search for multiple days (ex. Jun 20 ~ Jun 23)
          dates_for_filter = []
          search_date_range = ("#{date_from}".."#{date_to}")
          search_date_range.each do |the_date|
            dates_for_filter.append(the_date)
          end
          @reports_for_cart = @reports_for_cart.where(published_at: [dates_for_filter])
          report_for_tmp = @reports_for_cart
          @reports_for_cart = report_for_tmp.order("published_at ASC")
          @distinct_date = @reports_for_cart.select("distinct(published_at)")
          
          @reports = report_for_tmp.order("station_id ASC, published_at ASC").page(page)
          @reports_summarize = report_for_tmp.select('station_name, MAX(shares_percentage) as best_sp, MIN(shares_percentage) as worst_sp, MAX(closing_percentage) as best_cp, MIN(closing_percentage) as worst_cp').group(:station_id, :station_name)

          # Get all dates that best shares percentage occurs
          @best_sp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(station_name: item.station_name).where("shares_percentage > ? AND shares_percentage < ?", item.best_sp - 0.00001, item.best_sp + 0.00001)
            @best_sp_dates.append(matched_dates)
          end

          # Get all dates that worst shares percentage occurs
          @worst_sp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(station_name: item.station_name).where("shares_percentage > ? AND shares_percentage < ?", item.worst_sp - 0.00001, item.worst_sp + 0.00001)
            @worst_sp_dates.append(matched_dates)
          end

          # Get all dates that best closing percentage occurs
          @best_cp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(station_name: item.station_name).where("closing_percentage > ? AND closing_percentage < ?", item.best_cp - 0.00001, item.best_cp + 0.00001)
            @best_cp_dates.append(matched_dates)
          end

          # Get all dates that worst closing percentage occurs
          @worst_cp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(station_name: item.station_name).where("closing_percentage > ? AND closing_percentage < ?", item.worst_cp - 0.00001, item.worst_cp + 0.00001)
            @worst_cp_dates.append(matched_dates)
          end
        else
          if params[:station] == ""
            latest_date = @reports_for_cart.maximum('published_at')
            @reports_for_cart = @reports_for_cart.where(published_at: latest_date)
          end
        end
      elsif date.present? && search_type.present? && search_type == "Stock"
        #@station_id = params[:station_id]["id"]
        @reports_for_cart = MiReport.where(post_id: @post)
        @reports_for_cart = @reports_for_cart.where(station_id: @station.id, published_at: date)
        @reports = @reports_for_cart.order("stock_code ASC").page(page)
        @distinct_date = @reports_for_cart.select("distinct(published_at)")
      end
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
