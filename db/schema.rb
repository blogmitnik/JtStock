# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20200225020648) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "apn_clients", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.string   "platform"
    t.boolean  "enabled",    :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "devices", ["user_id"], :name => "index_devices_on_user_id"
  add_index "devices", ["uuid"], :name => "index_devices_on_uuid"

  create_table "mi_reports", :force => true do |t|
    t.integer  "post_id",                          :null => false
    t.integer  "yield_file_id",                    :null => false
    t.integer  "station_id",                       :null => false
    t.string   "stock_code",                       :null => false
    t.string   "stock_name",                       :null => false
    t.integer  "traded_volume",       :limit => 8, :null => false
    t.integer  "total_transactions",  :limit => 8, :null => false
    t.integer  "turnover",            :limit => 8, :null => false
    t.float    "opening_price"
    t.float    "highest_price"
    t.float    "lowest_price"
    t.float    "closing_price"
    t.string   "ups_and_downs",                    :null => false
    t.float    "change",                           :null => false
    t.float    "last_best_bid_price"
    t.integer  "last_best_bid_qty"
    t.float    "last_best_ask_price"
    t.float    "last_best_ask_qty"
    t.float    "pice_earnings_ratio"
    t.float    "shares_percentage",                :null => false
    t.float    "closing_percentage",               :null => false
    t.datetime "published_at",                     :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "mi_reports", ["closing_percentage"], :name => "index_mi_reports_on_closing_percentage"
  add_index "mi_reports", ["closing_price"], :name => "index_mi_reports_on_closing_price"
  add_index "mi_reports", ["highest_price"], :name => "index_mi_reports_on_highest_price"
  add_index "mi_reports", ["last_best_ask_price"], :name => "index_mi_reports_on_last_best_ask_price"
  add_index "mi_reports", ["last_best_ask_qty"], :name => "index_mi_reports_on_last_best_ask_qty"
  add_index "mi_reports", ["last_best_bid_price"], :name => "index_mi_reports_on_last_best_bid_price"
  add_index "mi_reports", ["last_best_bid_qty"], :name => "index_mi_reports_on_last_best_bid_qty"
  add_index "mi_reports", ["lowest_price"], :name => "index_mi_reports_on_lowest_price"
  add_index "mi_reports", ["opening_price"], :name => "index_mi_reports_on_opening_price"
  add_index "mi_reports", ["pice_earnings_ratio"], :name => "index_mi_reports_on_pice_earnings_ratio"
  add_index "mi_reports", ["post_id"], :name => "index_mi_reports_on_post_id"
  add_index "mi_reports", ["published_at"], :name => "index_mi_reports_on_published_at"
  add_index "mi_reports", ["shares_percentage"], :name => "index_mi_reports_on_shares_percentage"
  add_index "mi_reports", ["station_id", "published_at"], :name => "index_mi_reports_on_station_id_and_published_at"
  add_index "mi_reports", ["station_id"], :name => "index_mi_reports_on_station_id"
  add_index "mi_reports", ["stock_code", "stock_name"], :name => "index_mi_reports_on_stock_code_and_stock_name"
  add_index "mi_reports", ["stock_code"], :name => "index_mi_reports_on_stock_code"
  add_index "mi_reports", ["stock_name"], :name => "index_mi_reports_on_stock_name"
  add_index "mi_reports", ["total_transactions"], :name => "index_mi_reports_on_total_transactions"
  add_index "mi_reports", ["traded_volume"], :name => "index_mi_reports_on_traded_volume"
  add_index "mi_reports", ["turnover"], :name => "index_mi_reports_on_turnover"
  add_index "mi_reports", ["yield_file_id"], :name => "index_mi_reports_on_yield_file_id"

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "uid",                          :null => false
    t.string   "secret",                       :null => false
    t.string   "redirect_uri",                 :null => false
    t.string   "scopes",       :default => "", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.datetime "deleted_at"
    t.integer  "current_year"
    t.integer  "current_month"
    t.integer  "current_date"
  end

  add_index "posts", ["current_date"], :name => "index_posts_on_current_date"
  add_index "posts", ["current_month"], :name => "index_posts_on_current_month"
  add_index "posts", ["current_year"], :name => "index_posts_on_current_year"
  add_index "posts", ["deleted_at"], :name => "index_posts_on_deleted_at"
  add_index "posts", ["title"], :name => "index_posts_on_title"

  create_table "reports", :force => true do |t|
    t.integer  "post_id",                                                        :null => false
    t.integer  "yield_file_id",                                                  :null => false
    t.integer  "station_id",                                                     :null => false
    t.string   "station_name",                                                   :null => false
    t.integer  "traded_shares_num",   :limit => 8,                               :null => false
    t.integer  "turnover",            :limit => 8,                               :null => false
    t.integer  "total_transactions",  :limit => 8,                               :null => false
    t.decimal  "advance_decline_idx",              :precision => 5, :scale => 2, :null => false
    t.float    "shares_percentage",                                              :null => false
    t.float    "closing_percentage",                                             :null => false
    t.datetime "published_at",                                                   :null => false
    t.integer  "p_year",                                                         :null => false
    t.integer  "p_month",                                                        :null => false
    t.integer  "p_date",                                                         :null => false
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  add_index "reports", ["advance_decline_idx"], :name => "index_reports_on_advance_decline_idx"
  add_index "reports", ["p_year", "p_month", "p_date"], :name => "index_reports_on_p_year_and_p_month_and_p_date"
  add_index "reports", ["post_id"], :name => "index_reports_on_post_id"
  add_index "reports", ["published_at"], :name => "index_reports_on_published_at"
  add_index "reports", ["station_id", "p_year", "p_month", "p_date"], :name => "index_reports_on_station_id_and_p_year_and_p_month_and_p_date"
  add_index "reports", ["station_id", "published_at"], :name => "index_reports_on_station_id_and_published_at"
  add_index "reports", ["station_id"], :name => "index_reports_on_station_id"
  add_index "reports", ["station_name", "p_year", "p_month", "p_date"], :name => "index_reports_on_station_name_and_p_year_and_p_month_and_p_date"
  add_index "reports", ["station_name", "published_at"], :name => "index_reports_on_station_name_and_published_at"
  add_index "reports", ["station_name"], :name => "index_reports_on_station_name"
  add_index "reports", ["total_transactions"], :name => "index_reports_on_total_transactions"
  add_index "reports", ["traded_shares_num"], :name => "index_reports_on_traded_shares_num"
  add_index "reports", ["turnover"], :name => "index_reports_on_turnover"
  add_index "reports", ["yield_file_id"], :name => "index_reports_on_yield_file_id"

  create_table "stations", :force => true do |t|
    t.integer  "post_id",       :null => false
    t.integer  "yield_file_id", :null => false
    t.string   "name",          :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "stations", ["name"], :name => "index_stations_on_name"
  add_index "stations", ["yield_file_id"], :name => "index_stations_on_yield_file_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_token"
    t.datetime "facebook_expires_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_expires_at"], :name => "index_users_on_facebook_expires_at"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"
  add_index "users", ["provider"], :name => "index_users_on_provider"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid"

  create_table "yield_files", :force => true do |t|
    t.integer  "post_id",      :null => false
    t.string   "file_name",    :null => false
    t.integer  "total_row",    :null => false
    t.datetime "published_at", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "yield_files", ["file_name"], :name => "index_yield_files_on_file_name", :unique => true
  add_index "yield_files", ["post_id"], :name => "index_yield_files_on_post_id"

end
