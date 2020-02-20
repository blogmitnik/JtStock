module ReportsHelper
  def best_percentage_chart_data(reports)
    start_time = reports.last.published_at
    end_time = reports.first.published_at
    post_id = reports.first.post_id
    if controller.controller_name == "reports"
      # For search build page
      datetime = reports.select("distinct(published_at)")
    else
      # For general build page
      datetime = Report.where("post_id = ? AND published_at BETWEEN ? AND ?", post_id, start_time, end_time).select("distinct(published_at)")
    end
    datetime.map do |date|
    {
      published_at: date.published_at.to_datetime.to_formatted_s(:long),
      # Top1 shares percentage & closing percentage & station name
      best1_shares_percentage: Report.group_shares_percentage_by_date(date.published_at).first.try(:best_shares_percentage),
      best1_closing_percentage: Report.group_closing_percentage_by_date(date.published_at).first.try(:best_closing_percentage),
      best1_shares_percentage_index: Report.group_shares_percentage_by_date(date.published_at).first.try(:station_name),
      best1_closing_percentage_index: Report.group_closing_percentage_by_date(date.published_at).first.try(:station_name),
      
      # Top2 shares percentage & closing percentage & station name
      best2_shares_percentage: Report.group_shares_percentage_by_date(date.published_at).offset(1).first.try(:best_shares_percentage),
      best2_closing_percentage: Report.group_closing_percentage_by_date(date.published_at).offset(1).first.try(:best_closing_percentage),
      best2_shares_percentage_index: Report.group_shares_percentage_by_date(date.published_at).offset(1).first.try(:station_name),
      best2_closing_percentage_index: Report.group_closing_percentage_by_date(date.published_at).offset(1).first.try(:station_name),
      
      # Top3 shares percentage & closing percentage & station name
      best3_shares_percentage: Report.group_shares_percentage_by_date(date.published_at).offset(2).first.try(:best_shares_percentage),
      best3_closing_percentage: Report.group_closing_percentage_by_date(date.published_at).offset(2).first.try(:best_closing_percentage),
      best3_shares_percentage_index: Report.group_shares_percentage_by_date(date.published_at).offset(2).first.try(:station_name),
      best3_closing_percentage_index: Report.group_closing_percentage_by_date(date.published_at).offset(2).first.try(:station_name),
      
      # Top4 shares percentage & closing percentage & station name
      best4_shares_percentage: Report.group_shares_percentage_by_date(date.published_at).offset(3).first.try(:best_shares_percentage),
      best4_closing_percentage: Report.group_closing_percentage_by_date(date.published_at).offset(3).first.try(:best_closing_percentage),
      best4_shares_percentage_index: Report.group_shares_percentage_by_date(date.published_at).offset(3).first.try(:station_name),
      best4_closing_percentage_index: Report.group_closing_percentage_by_date(date.published_at).offset(3).first.try(:station_name),
      
      # Top5 shares percentage & closing percentage & station name
      best5_shares_percentage: Report.group_shares_percentage_by_date(date.published_at).offset(4).first.try(:best_shares_percentage),
      best5_closing_percentage: Report.group_closing_percentage_by_date(date.published_at).offset(4).first.try(:best_closing_percentage),
      best5_shares_percentage_index: Report.group_shares_percentage_by_date(date.published_at).offset(4).first.try(:station_name),
      best5_closing_percentage_index: Report.group_closing_percentage_by_date(date.published_at).offset(4).first.try(:station_name),
    }
    end
  end

  def config_accu_yield_bar_chart_data(reports)
    station = reports.first.station_name
    config = reports.first.config
    datetime_start = reports.minimum('published_at')
    datetime_end = reports.maximum('published_at')

    if params[:data_period].present? && params[:data_period] == "hourly"
      # If parameter present, show each hour's report
      overflow_accu_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate > ?", config, station, datetime_start, datetime_end, 100.00).count
      great_accu_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate >= ? AND yield_rate <= ?", config, station, datetime_start, datetime_end, 99.51, 100.00).count
      bad_accu_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate >= ? AND yield_rate <= ?", config, station, datetime_start, datetime_end, 90.00, 99.50).count
      worse_accu_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate >= ? AND yield_rate <= ?", config, station, datetime_start, datetime_end, 0.00, 89.99).count
      no_input_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate IS NULL", config, station, datetime_start, datetime_end).count
    else
      # By default, only show latest hour's report for each day
      overflow_accu_yield = reports.where("yield_rate > ?", 100.00).count
      great_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 99.51, 100.00).count
      bad_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 90.00, 99.50).count
      worse_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 0.00, 89.99).count
      no_input_yield = reports.where("yield_rate IS NULL").count
    end

    overflow_accu_yield_rate = ((overflow_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    great_accu_yield_rate = ((great_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_accu_yield_rate = ((bad_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_accu_yield_rate = ((worse_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_accu_yield, great_accu_yield, bad_accu_yield, worse_accu_yield, no_input_yield]
    title = ['Overflow Accu Yield', 'Verified Accu Yield', 'Bad Accu Yield', 'Worse Accu Yield', 'No Input']
    percent = [overflow_accu_yield_rate, great_accu_yield_rate, bad_accu_yield_rate, worse_accu_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end

  def config_daily_yield_bar_chart_data(reports)
    station = reports.first.station_name
    config = reports.first.config
    datetime_start = reports.minimum('published_at')
    datetime_end = reports.maximum('published_at')

    if params[:data_period].present? && params[:data_period] == "hourly"
      # If parameter present, show each hour's report
      overflow_daily_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate_today > ?", config, station, datetime_start, datetime_end, 100.00).count
      great_daily_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate_today >= ? AND yield_rate_today <= ?", config, station, datetime_start, datetime_end, 99.51, 100.00).count
      bad_daily_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate_today >= ? AND yield_rate_today <= ?", config, station, datetime_start, datetime_end, 90.00, 99.50).count
      worse_daily_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate_today >= ? AND yield_rate_today <= ?", config, station, datetime_start, datetime_end, 0.00, 89.99).count
      no_input_yield = Report.where("config = ? AND station_name = ? AND published_at BETWEEN ? AND ? AND yield_rate_today IS NULL", config, station, datetime_start, datetime_end).count
    else
      # By default, only show latest hour's report for each day
      overflow_daily_yield = reports.where("yield_rate_today > ?", 100.00).count
      great_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 99.51, 100.00).count
      bad_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 90.00, 99.50).count
      worse_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 0.00, 89.99).count
      no_input_yield = reports.where("yield_rate_today IS NULL").count
    end

    overflow_daily_yield_rate = ((overflow_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    great_daily_yield_rate = ((great_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_daily_yield_rate = ((bad_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_daily_yield_rate = ((worse_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_daily_yield, great_daily_yield, bad_daily_yield, worse_daily_yield, no_input_yield]
    title = ['Overflow Daily Yield', 'Verified Daily Yield', 'Bad Daily Yield', 'Worse Daily Yield', 'No Input']
    percent = [overflow_daily_yield_rate, great_daily_yield_rate, bad_daily_yield_rate, worse_daily_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end
end
