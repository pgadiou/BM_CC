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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180612162127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.boolean "lack_financials"
    t.boolean "lack_description"
    t.boolean "losses"
    t.boolean "unrelated_activity"
    t.boolean "lack_information"
    t.boolean "unrelated_function"
    t.boolean "group"
    t.boolean "turnover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_version_id"
    t.string "Company name"
    t.string "Address"
    t.string "Website"
    t.string "Country"
    t.string "City"
    t.string "BvD ID number"
    t.string "NACE / NAF code"
    t.string "trade_description_en"
    t.string "trade_description_original"
    t.integer "Turnover 2011"
    t.integer "Turnover 2012"
    t.integer "Turnover 2013"
    t.integer "EBIT 2011"
    t.integer "EBIT 2012"
    t.integer "EBIT 2013"
    t.decimal "ros_1"
    t.decimal "ros_2"
    t.decimal "ros_3"
    t.decimal "ros_avg"
    t.decimal "fcmu_1"
    t.decimal "fcmu_2"
    t.decimal "fcmu_3"
    t.decimal "fcmu_avg"
    t.boolean "accepted"
    t.boolean "unset", default: true
    t.index ["project_version_id"], name: "index_companies_on_project_version_id"
  end

  create_table "project_versions", force: :cascade do |t|
    t.bigint "project_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "open_tab"
    t.index ["project_id"], name: "index_project_versions_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "client"
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "companies", "project_versions"
  add_foreign_key "project_versions", "projects"
  add_foreign_key "projects", "users"
end
