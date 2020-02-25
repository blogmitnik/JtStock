class CreateMiReports < ActiveRecord::Migration
  def change
    create_table :mi_reports do |t|
      t.references :post,                 null: false
      t.references :yield_file,           null: false
      t.references :station,              null: false
      t.string :stock_code,       	      null: false #證券代號
      t.string :stock_name,               null: false #證券名稱
      t.integer :traded_volume,           null: false, limit: 8 #成交股數
      t.integer :total_transactions,      null: false, limit: 8 #成交筆數
      t.integer :turnover,                null: false, limit: 8 #成交金額
      t.float :opening_price,             null: true, precision: 5, scale: 2 #開盤價
      t.float :highest_price,             null: true, precision: 5, scale: 2 #最高價
      t.float :lowest_price,              null: true, precision: 5, scale: 2 #最低價
      t.float :closing_price,             null: true, precision: 5, scale: 2 #收盤價
      t.string :ups_and_downs,            null: false #漲跌
      t.float :change,     	     	        null: false, precision: 5, scale: 2 #漲跌價差
      t.float :last_best_bid_price,       null: true, precision: 5, scale: 2 #最後揭示買價
      t.integer :last_best_bid_qty,       null: true #最後揭示買量
      t.float :last_best_ask_price,       null: true, precision: 5, scale: 2 #最後揭示賣價
      t.float :last_best_ask_qty,         null: true #最後揭示賣量
      t.float :pice_earnings_ratio,	      null: true, precision: 5, scale: 2 #本益比(PER)
      t.float :shares_percentage,         null: false, precision: 5, scale: 2 #股數百分比
      t.float :closing_percentage,        null: false, precision: 5, scale: 2 #成交百分比
      t.datetime :published_at,           null: false

      t.timestamps
    end

    add_index :mi_reports, :post_id
    add_index :mi_reports, :yield_file_id
    add_index :mi_reports, :station_id
    add_index :mi_reports, [:station_id, :published_at ]
    add_index :mi_reports, :stock_code
    add_index :mi_reports, :stock_name
    add_index :mi_reports, [:stock_code, :stock_name]
    add_index :mi_reports, :traded_volume
    add_index :mi_reports, :total_transactions
  	add_index :mi_reports, :turnover
  	add_index :mi_reports, :opening_price
  	add_index :mi_reports, :highest_price
  	add_index :mi_reports, :lowest_price
  	add_index :mi_reports, :closing_price
  	add_index :mi_reports, :last_best_bid_price
  	add_index :mi_reports, :last_best_bid_qty
  	add_index :mi_reports, :last_best_ask_price
  	add_index :mi_reports, :last_best_ask_qty
  	add_index :mi_reports, :pice_earnings_ratio
  	add_index :mi_reports, :shares_percentage
  	add_index :mi_reports, :closing_percentage
    add_index :mi_reports, :published_at
  end
end
