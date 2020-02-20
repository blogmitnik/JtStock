class AddTimeStampToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :current_year,  :integer
  	add_column :posts, :current_month, :integer
  	add_column :posts, :current_date,  :integer

    add_index :posts, :current_year
    add_index :posts, :current_month
    add_index :posts, :current_date
  end
end
