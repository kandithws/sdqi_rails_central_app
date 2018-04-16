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

ActiveRecord::Schema.define(version: 20180416102659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.decimal "total_amount"
    t.date "payment_deadline"
    t.boolean "payment_confirm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "payment_method"
    t.string "payment_evidence_file_name"
    t.string "payment_evidence_content_type"
    t.integer "payment_evidence_file_size"
    t.datetime "payment_evidence_updated_at"
    t.string "omise_barcode_url"
    t.datetime "omise_barcode_expires_at"
    t.datetime "omise_barcode_created_at"
    t.string "omise_source_id"
    t.string "omise_charge_id"
    t.string "barcode_file_file_name"
    t.string "barcode_file_content_type"
    t.integer "barcode_file_file_size"
    t.datetime "barcode_file_updated_at"
    t.string "barcode_number"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "license_plate_number"
    t.string "brand"
    t.string "car_model_name"
    t.string "car_model_year"
    t.string "color"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "car_img_file_name"
    t.string "car_img_content_type"
    t.integer "car_img_file_size"
    t.datetime "car_img_updated_at"
    t.index ["user_id"], name: "index_cars_on_user_id"
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log"
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "toll_booths", force: :cascade do |t|
    t.string "name"
    t.decimal "latitute"
    t.decimal "longtitude"
    t.decimal "toll_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key"
  end

  create_table "toll_fee_records", force: :cascade do |t|
    t.bigint "toll_booth_id"
    t.datetime "timestamp"
    t.bigint "car_id"
    t.bigint "bill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["bill_id"], name: "index_toll_fee_records_on_bill_id"
    t.index ["car_id"], name: "index_toll_fee_records_on_car_id"
    t.index ["toll_booth_id"], name: "index_toll_fee_records_on_toll_booth_id"
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
    t.string "name_prefix"
    t.string "firstname"
    t.string "lastname"
    t.string "address"
    t.string "phone_number"
    t.string "driving_license_number"
    t.boolean "admin"
    t.string "driving_license_img_file_name"
    t.string "driving_license_img_content_type"
    t.integer "driving_license_img_file_size"
    t.datetime "driving_license_img_updated_at"
    t.boolean "license_verified"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bills", "users"
  add_foreign_key "cars", "users"
  add_foreign_key "toll_fee_records", "bills"
  add_foreign_key "toll_fee_records", "cars"
  add_foreign_key "toll_fee_records", "toll_booths"
end
