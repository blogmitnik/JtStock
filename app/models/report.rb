require 'fileutils'
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class Report < ActiveRecord::Base
  attr_accessible :post_id, :yield_file_id, :station_id, :station_name, :traded_shares_num, :turnover, :total_transactions, :advance_decline_idx, :shares_percentage, :closing_percentage, :published_at, :p_year, :p_month, :p_date, :created_at, :updated_at
  belongs_to :post
  belongs_to :yield_file
  belongs_to :station
  validates :post_id, :yield_file_id, :station_id, :station_name, :traded_shares_num, :turnover, :total_transactions, :advance_decline_idx, :shares_percentage, :closing_percentage, :published_at, :p_year, :p_month, :p_date, presence: true

  # Set yield report records per page
  paginates_per 90

  before_validation do
    if published_at
      self.p_year = published_at.year
      self.p_month = published_at.month
      self.p_date = published_at.mday
    end
  end

  SORT_NAMES = %w(
    published_at station_name
  )

  def self.sort_names
    SORT_NAMES
  end

  def self.group_shares_percentage_by_date(date_time)
    reports = where("published_at = ?", date_time)
    reports = reports.group("station_name")
    reports = reports.select("station_name, max(shares_percentage) as best_shares_percentage")
    reports = reports.order("best_shares_percentage DESC")
  end

  def self.group_closing_percentage_by_date(date_time)
    reports = where("published_at = ?", date_time)
    reports = reports.group("station_name")
    reports = reports.select("station_name, max(closing_percentage) as best_closing_percentage")
    reports = reports.order("best_closing_percentage DESC")
  end

  # The 'import' function can be used both on web and rake script
  def self.import_data(file, filename, post)
    # Check filename
    if csvfile = YieldFile.find_by_file_name(filename)
      yf_id = csvfile.id
    else
      line_count = CSV.open(file, "r", :encoding => 'big5').readlines.count - 1
      file_date = Time.parse(filename.gsub('.csv', '')).strftime('%Y-%m-%d %H:%M:%S').to_s
      yield_file = YieldFile.create(post_id: post.id, file_name: filename, total_row: line_count, published_at: file_date)
      yf_id = yield_file.id
    end

    GC.disable

    Report.transaction do
      records = []
      columns = [:post_id, :yield_file_id, :station_id, :station_name, :traded_shares_num, :turnover, :total_transactions, :advance_decline_idx, :shares_percentage, :closing_percentage, :published_at, :p_year, :p_month, :p_date]
      column_header = ['分類指數名稱', '成交股數', '成交金額', '成交筆數', '漲跌指數']
      
      sum_of_shares = 0
      sum_of_closing = 0
      CSV.foreach(file, {encoding: "big5", quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
          # We only need data from row "水泥類指數" to "其他類指數"
          if rowno > 1 and rowno < 32
            sum_of_shares += row['成交股數'].gsub(',', '').to_i
            sum_of_closing += row['成交金額'].gsub(',', '').to_i
          end
      end
      
      CSV.foreach(file, {encoding: "big5", quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
        if rowno > 1 and rowno < 32
          if station = Station.find_by_name_and_post_id(row['分類指數名稱'].strip, post.id)
            sta_id = station.id
          else
            station = Station.create(post_id: post.id, yield_file_id: yf_id, name: row['分類指數名稱'].strip.to_s)
            sta_id = station.id
          end

          shares_percentage = ((row['成交股數'].gsub(',', '').to_f / sum_of_shares.to_f) * 100).round(2)
          closing_percentage = ((row['成交金額'].gsub(',', '').to_f / sum_of_closing.to_f) * 100).round(2)

          time_now = Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s
          record = [post.id, yf_id, sta_id, row['分類指數名稱'].strip.to_s, row['成交股數'].gsub(',', ''), row['成交金額'].gsub(',', ''), row['成交筆數'].gsub(',', ''), row['漲跌指數'], 
            shares_percentage, closing_percentage,
            Time.parse(filename.gsub('.csv', '')).strftime('%Y-%m-%d %H:%M:%S').to_s, Time.parse(filename.gsub('.csv', '').to_s).year, Time.parse(filename.gsub('.csv', '').to_s).month, Time.parse(filename.gsub('.csv', '').to_s).day,
            time_now, time_now]
          records << record
        end
      end

      values = records.map{ |record| "(#{record[0]}, #{record[1]}, #{record[2]}, '#{record[3]}', #{record[4]}, #{record[5]}, #{record[6]}, #{record[7]}, #{record[8]}, #{record[9]}, '#{record[10]}', #{record[11]}, #{record[12]}, #{record[13]}, '#{record[14]}', '#{record[15]}')" }.join(",")
      sql = "INSERT INTO `#{self.table_name}` (`post_id`,`yield_file_id`,`station_id`,`station_name`,`traded_shares_num`,`turnover`,`total_transactions`,`advance_decline_idx`,`shares_percentage`,`closing_percentage`,`published_at`,`p_year`,`p_month`,`p_date`,`created_at`,`updated_at`) VALUES #{values}"
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        conn.execute(sql)
      end
    end

    the_year = filename[0, 4]
    the_month = filename[4, 6]
    the_date = filename[6, 8]
    post.update_attributes(current_year: the_year, current_month: the_month, current_date: the_date)
  end
end
