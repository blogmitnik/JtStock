module MiReportsHelper
  def config_best_percentage_chart_data(reports, station_id)
    start_time = reports.last.published_at
    end_time = reports.first.published_at
    post_id = reports.first.post_id
    if controller.controller_name == "reports"
      # For search build page
      datetime = reports.select("distinct(published_at)")
    else
      # For general build page
      datetime = MiReport.where("post_id = ? AND published_at BETWEEN ? AND ?", post_id, start_time, end_time).select("distinct(published_at)")
    end
    
    datetime.map do |date|
    {
      published_at: date.published_at.to_datetime.to_formatted_s(:long),
      # Top1 shares percentage & closing percentage & station name
      best1_shares_percentage: MiReport.group_sp_by_date(date.published_at, station_id).first.try(:best_shares_percentage),
      best1_closing_percentage: MiReport.group_cp_by_date(date.published_at, station_id).first.try(:best_closing_percentage),
      best1_shares_percentage_index: MiReport.group_sp_by_date(date.published_at, station_id).first.try(:stock_name),
      best1_closing_percentage_index: MiReport.group_cp_by_date(date.published_at, station_id).first.try(:stock_name),
      
      # Top2 shares percentage & closing percentage & station name
      best2_shares_percentage: MiReport.group_sp_by_date(date.published_at, station_id).offset(1).first.try(:best_shares_percentage),
      best2_closing_percentage: MiReport.group_cp_by_date(date.published_at, station_id).offset(1).first.try(:best_closing_percentage),
      best2_shares_percentage_index: MiReport.group_sp_by_date(date.published_at, station_id).offset(1).first.try(:stock_name),
      best2_closing_percentage_index: MiReport.group_cp_by_date(date.published_at, station_id).offset(1).first.try(:stock_name),
      
      # Top3 shares percentage & closing percentage & station name
      best3_shares_percentage: MiReport.group_sp_by_date(date.published_at, station_id).offset(2).first.try(:best_shares_percentage),
      best3_closing_percentage: MiReport.group_cp_by_date(date.published_at, station_id).offset(2).first.try(:best_closing_percentage),
      best3_shares_percentage_index: MiReport.group_sp_by_date(date.published_at, station_id).offset(2).first.try(:stock_name),
      best3_closing_percentage_index: MiReport.group_cp_by_date(date.published_at, station_id).offset(2).first.try(:stock_name),
      
      # Top4 shares percentage & closing percentage & station name
      best4_shares_percentage: MiReport.group_sp_by_date(date.published_at, station_id).offset(3).first.try(:best_shares_percentage),
      best4_closing_percentage: MiReport.group_cp_by_date(date.published_at, station_id).offset(3).first.try(:best_closing_percentage),
      best4_shares_percentage_index: MiReport.group_sp_by_date(date.published_at, station_id).offset(3).first.try(:stock_name),
      best4_closing_percentage_index: MiReport.group_cp_by_date(date.published_at, station_id).offset(3).first.try(:stock_name),
      
      # Top5 shares percentage & closing percentage & station name
      best5_shares_percentage: MiReport.group_sp_by_date(date.published_at, station_id).offset(4).first.try(:best_shares_percentage),
      best5_closing_percentage: MiReport.group_cp_by_date(date.published_at, station_id).offset(4).first.try(:best_closing_percentage),
      best5_shares_percentage_index: MiReport.group_sp_by_date(date.published_at, station_id).offset(4).first.try(:stock_name),
      best5_closing_percentage_index: MiReport.group_cp_by_date(date.published_at, station_id).offset(4).first.try(:stock_name),
    }
    end
  end
end