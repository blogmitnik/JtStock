class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :post,                 null: false
      t.references :yield_file,           null: false
      t.references :station,              null: false
      t.string :station_name,             null: false
      t.integer :traded_shares_num,       null: false, limit: 8
      t.integer :turnover,                null: false, limit: 8
      t.integer :total_transactions,      null: false, limit: 8
      t.decimal :advance_decline_idx,     null: false, precision: 5, scale: 2
      t.float :shares_percentage,         null: false, precision: 5, scale: 2
      t.float :closing_percentage,        null: false, precision: 5, scale: 2
      t.datetime :published_at,           null: false
      t.integer :p_year,                  null: false
      t.integer :p_month,                 null: false
      t.integer :p_date,                  null: false

      t.timestamps
    end

    add_index :reports, :post_id
    add_index :reports, :yield_file_id
    add_index :reports, :station_id
    add_index :reports, [:station_id, :published_at ]
    add_index :reports, :station_name
    add_index :reports, [:station_name, :published_at ]
    add_index :reports, :traded_shares_num
    add_index :reports, :turnover
    add_index :reports, :total_transactions
    add_index :reports, :advance_decline_idx
    add_index :reports, :published_at
    add_index :reports, [ :p_year, :p_month, :p_date ]
    add_index :reports, [ :station_id, :p_year, :p_month, :p_date ]
    add_index :reports, [ :station_name, :p_year, :p_month, :p_date ]
  end
end
