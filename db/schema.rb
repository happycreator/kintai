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

ActiveRecord::Schema.define(version: 20190214113906) do

  create_table "attendance_logs", force: :cascade do |t|
    t.date     "attendance_date"
    t.datetime "arriving_at_before_update"
    t.datetime "leaving_at_before_update"
    t.datetime "arriving_at_after_update"
    t.datetime "leaving_at_after_update"
    t.integer  "change_confirmation_approver_id"
    t.date     "approval_date"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.datetime "arriving_at"
    t.datetime "leaving_at"
    t.string   "note"
    t.date     "attendance_date"
    t.datetime "overtime"
    t.text     "task_memo"
    t.integer  "change_confirmation_approver_id"
    t.integer  "change_confirmation_status"
    t.integer  "overwork_status"
    t.integer  "overwork_approver_id"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "monthly_confirmation_approver_id"
    t.integer  "monthly_confirmation_status"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "user_working_places", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "working_place_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id", "working_place_id"], name: "index_user_working_places_on_user_id_and_working_place_id", unique: true
    t.index ["user_id"], name: "index_user_working_places_on_user_id"
    t.index ["working_place_id"], name: "index_user_working_places_on_working_place_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                 default: false
    t.string   "activation_digest"
    t.boolean  "activated",             default: false
    t.datetime "activated_at"
    t.integer  "employee_number"
    t.integer  "role"
    t.datetime "base_attendance_time"
    t.datetime "start_attendance_time"
    t.datetime "end_attendance_time"
    t.string   "card_id"
    t.boolean  "is_senior"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "working_places", force: :cascade do |t|
    t.integer  "working_place_number"
    t.string   "working_place_name"
    t.string   "working_type"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end
