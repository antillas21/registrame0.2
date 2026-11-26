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

ActiveRecord::Schema[8.1].define(version: 2026_11_26_045333) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "state_id"
    t.integer "country_id"
    t.integer "sector_id"
    t.index ["city"], name: "index_companies_on_city"
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["name"], name: "index_companies_on_name"
    t.index ["sector_id"], name: "index_companies_on_sector_id"
    t.index ["state_id"], name: "index_companies_on_state_id"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["name"], name: "index_countries_on_name"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "venue"
    t.text "info"
    t.date "date"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "website"
  end

  create_table "interests", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "interests_people", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "interest_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["interest_id"], name: "index_interests_people_on_interest_id"
    t.index ["person_id"], name: "index_interests_people_on_person_id"
  end

  create_table "name_badges", id: :serial, force: :cascade do |t|
    t.string "name"
    t.float "width"
    t.float "height"
    t.float "left"
    t.float "right"
    t.float "top"
    t.float "bottom"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "font_size"
    t.index ["name"], name: "index_name_badges_on_name"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "email"
    t.string "job"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "registration_id"
    t.integer "company_id"
    t.string "phone"
    t.boolean "printed", default: false
    t.index ["company_id"], name: "index_people_on_company_id"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["printed"], name: "index_people_on_printed"
    t.index ["registration_id"], name: "index_people_on_registration_id"
  end

  create_table "people_promotions", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "promotion_id"
    t.index ["person_id"], name: "index_people_promotions_on_person_id"
    t.index ["promotion_id"], name: "index_people_promotions_on_promotion_id"
  end

  create_table "promotions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "sectors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["name"], name: "index_sectors_on_name", unique: true
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["name"], name: "index_states_on_name"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "admin", default: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
