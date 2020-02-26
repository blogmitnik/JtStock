require 'fileutils'
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class MiReport < ActiveRecord::Base
  attr_accessible :post_id, :yield_file_id, :station_id, :stock_code, :stock_name, :traded_volume, :total_transactions, :turnover, :opening_price, :highest_price, :lowest_price, :closing_price, :ups_and_downs, :change, :last_best_bid_price, :last_best_bid_qty, :last_best_ask_price, :last_best_ask_qty, :pice_earnings_ratio, :shares_percentage, :closing_percentage, :published_at, :created_at, :updated_at
  belongs_to :post
  belongs_to :yield_file
  belongs_to :station
  validates :post_id, :yield_file_id, :station_id, :stock_code, :stock_name, :traded_volume, :total_transactions, :turnover, :opening_price, :highest_price, :lowest_price, :closing_price, :ups_and_downs, :change, :last_best_bid_price, :last_best_bid_qty, :last_best_ask_price, :last_best_ask_qty, :pice_earnings_ratio, :shares_percentage, :closing_percentage, :published_at, :created_at, :updated_at, presence: true

  # Set yield report records per page
  paginates_per 1000

  def self.group_sp_by_date(date_time)
    reports = where("published_at = ?", date_time)
    reports = reports.group("stock_name")
    reports = reports.select("stock_name, max(shares_percentage) as best_shares_percentage")
    reports = reports.order("best_shares_percentage DESC")
  end

  def self.group_cp_by_date(date_time)
    reports = where("published_at = ?", date_time)
    reports = reports.group("stock_name")
    reports = reports.select("stock_name, max(closing_percentage) as best_closing_percentage")
    reports = reports.order("best_closing_percentage DESC")
  end

  # The 'import' function can be used both on web and rake script
  def self.import_data(file, filename, post)
    # Check filename
    if csvfile = YieldFile.find_by_file_name(filename)
      yf_id = csvfile.id
    else
      line_count = CSV.open(file, "r", :encoding => 'big5').readlines.count - 2
      file_date = Time.parse(filename[12, 8]).strftime('%Y-%m-%d %H:%M:%S').to_s
      yield_file = YieldFile.create(post_id: post.id, file_name: filename, total_row: line_count, published_at: file_date)
      yf_id = yield_file.id
    end

    GC.disable

    Report.transaction do
      records = []
      columns = [:post_id, :yield_file_id, :station_id, :stock_code, :stock_name, :traded_volume, :total_transactions, :turnover, :opening_price, :highest_price, :lowest_price, :closing_price, :ups_and_downs, :change, :last_best_bid_price, :last_best_bid_qty, :last_best_ask_price, :last_best_ask_qty, :pice_earnings_ratio, :shares_percentage, :closing_percentage, :published_at]
      # Define CSV header columns
      column_header = ['證券代號', '證券名稱', '成交股數', '成交筆數', '成交金額', '開盤價', '最高價', '最低價', '收盤價', '漲跌', '漲跌價差', '最後揭示買價', '最後揭示買量', '最後揭示賣價', '最後揭示賣量', '本益比']
      # Define mapping table
      index_name_table=  ['N/A', '水泥類指數', '食品類指數', '塑膠類指數', '紡織纖維類指數', '電機機械類指數', '電器電纜類指數', '化學生技醫療類指數', '玻璃陶瓷類指數', '造紙類指數', '鋼鐵類指數', '橡膠類指數', '汽車類指數', '電子類指數', '建材營造類指數', '航運業類指數', '觀光事業類指數', '金融保險類指數', '貿易百貨類指數', 'N/A', '其他類指數', '化學類指數', '生技醫療類指數', '油電燃氣類指數', '半導體類指數', '電腦及週邊設備類指數', '光電類指數', '通信網路類指數', '電子零組件類指數', '電子通路類指數', '資訊服務類指數', '其他電子類指數']
      
      sum_of_shares = 0
      sum_of_closing = 0

      CSV.foreach(file, {encoding: "big5", quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
          # We only need data from row "水泥類指數" to "其他類指數"
          if rowno > 2 and rowno < line_count.to_i-4
          	sum_of_shares += row['成交股數'].gsub(',', '').to_i
            sum_of_closing += row['成交金額'].gsub(',', '').to_i
          end
      end
      
      CSV.foreach(file, {encoding: "big5", quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
        if rowno > 2 and rowno < line_count.to_i-4
          csv_type_num = filename[9, 2].to_i
          station = Station.find_by_name_and_post_id(index_name_table[csv_type_num], post.id)
          sta_id = station.id

          shares_percentage = ((row['成交股數'].gsub(',', '').to_f / sum_of_shares.to_f) * 100).round(2)
          closing_percentage = ((row['成交金額'].gsub(',', '').to_f / sum_of_closing.to_f) * 100).round(2)

          if row['本益比'].to_s == ""
          	row['本益比'] = '999999999'
          end

          time_now = Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s
          record = [post.id, yf_id, sta_id, row['證券代號'], row['證券名稱'].strip.to_s, row['成交股數'].gsub(',', ''), row['成交筆數'].gsub(',', ''), row['成交金額'].gsub(',', ''), row['開盤價'].gsub(',', '').to_s.gsub('--', '999999999'), row['最高價'].gsub(',', '').to_s.gsub('--', '999999999'), row['最低價'].gsub(',', '').to_s.gsub('--', '999999999'), row['收盤價'].gsub(',', '').to_s.gsub('--', '999999999'), row['漲跌'].strip.to_s, row['漲跌價差'], row['最後揭示買價'].gsub(',', '').to_s.gsub('--', '999999999'), row['最後揭示買量'].gsub(',', '').to_s.gsub('--', '999999999'), row['最後揭示賣價'].gsub(',', '').to_s.gsub('--', '999999999'), row['最後揭示賣量'].gsub(',', '').to_s.gsub('--', '999999999'), row['本益比'].gsub(',', ''), 
            shares_percentage, closing_percentage,
            Time.parse(filename[12, 8]).strftime('%Y-%m-%d %H:%M:%S').to_s,
            time_now, time_now]
          records << record
        end
      end

      values = records.map{ |record| "(#{record[0]}, #{record[1]}, #{record[2]}, '#{record[3]}', '#{record[4]}', #{record[5]}, #{record[6]}, #{record[7]}, #{record[8]}, #{record[9]}, #{record[10]}, #{record[11]}, '#{record[12]}', #{record[13]}, #{record[14]}, #{record[15]}, #{record[16]}, #{record[17]}, #{record[18]}, #{record[19]}, #{record[20]}, '#{record[21]}', '#{record[22]}', '#{record[23]}')" }.join(",").gsub('999999999', 'NULL')
      sql = "INSERT INTO `#{self.table_name}` (`post_id`,`yield_file_id`,`station_id`,`stock_code`,`stock_name`,`traded_volume`,`total_transactions`,`turnover`,`opening_price`,`highest_price`,`lowest_price`,`closing_price`,`ups_and_downs`,`change`,`last_best_bid_price`,`last_best_bid_qty`,`last_best_ask_price`,`last_best_ask_qty`,`pice_earnings_ratio`,`shares_percentage`,`closing_percentage`,`published_at`,`created_at`,`updated_at`) VALUES #{values}"
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        conn.execute(sql)
      end
    end

    # the_year = filename[0, 4]
    # the_month = filename[4, 6]
    # the_date = filename[6, 8]
    # post.update_attributes(current_year: the_year, current_month: the_month, current_date: the_date)
  end

end
