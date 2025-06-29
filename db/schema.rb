# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_06_29_152320) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_positions", force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string "company_name", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "location", null: false
    t.text "requirements"
    t.text "identity_fields_required"
    t.boolean "availability_required", default: false
    t.text "legal_disclosures"
    t.text "video_questions"
    t.text "other_information"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_name"], name: "index_positions_on_company_name"
    t.index ["location"], name: "index_positions_on_location"
    t.index ["title"], name: "index_positions_on_title"
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "assigned_user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "role"
    t.string "location"
    t.string "status", default: "scheduled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_user_id"], name: "index_shifts_on_assigned_user_id"
    t.index ["organization_id"], name: "index_shifts_on_organization_id"
    t.index ["start_time"], name: "index_shifts_on_start_time"
  end

  create_table "time_off_requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "reason"
    t.string "status", default: "pending", null: false
    t.integer "approved_by_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_time_off_requests_on_status"
    t.index ["user_id"], name: "index_time_off_requests_on_user_id"
  end

  create_table "timesheets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "shift_id"
    t.datetime "clock_in_time"
    t.datetime "clock_out_time"
    t.string "status", default: "pending"
    t.decimal "hours_worked", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_timesheets_on_shift_id"
    t.index ["user_id"], name: "index_timesheets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "full_name"
    t.string "role"
    t.integer "organization_id"
    t.decimal "hourly_rate"
    t.string "position"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

end
