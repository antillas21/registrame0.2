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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20110421164631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address1",   limit: 255
    t.string   "address2",   limit: 255
    t.string   "city",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "state_id"
    t.integer  "country_id"
    t.integer  "sector_id"
  end

  add_index "companies", ["city"], name: "index_companies_on_city", using: :btree
  add_index "companies", ["country_id"], name: "index_companies_on_country_id", using: :btree
  add_index "companies", ["name"], name: "index_companies_on_name", using: :btree
  add_index "companies", ["sector_id"], name: "index_companies_on_sector_id", using: :btree
  add_index "companies", ["state_id"], name: "index_companies_on_state_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "venue",      limit: 255
    t.text     "info"
    t.date     "date"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "website",    limit: 255
  end

  create_table "interests", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "interests_people", id: false, force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "interest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "interests_people", ["interest_id"], name: "index_interests_people_on_interest_id", using: :btree
  add_index "interests_people", ["person_id"], name: "index_interests_people_on_person_id", using: :btree

  create_table "name_badges", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.float    "width"
    t.float    "height"
    t.float    "left"
    t.float    "right"
    t.float    "top"
    t.float    "bottom"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "font_size"
  end

  add_index "name_badges", ["name"], name: "index_name_badges_on_name", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "fname",           limit: 255
    t.string   "lname",           limit: 255
    t.string   "email",           limit: 255
    t.string   "job",             limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "registration_id"
    t.integer  "company_id"
    t.string   "phone",           limit: 255
    t.boolean  "printed",                     default: false
  end

  add_index "people", ["company_id"], name: "index_people_on_company_id", using: :btree
  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["printed"], name: "index_people_on_printed", using: :btree
  add_index "people", ["registration_id"], name: "index_people_on_registration_id", using: :btree

  create_table "people_promotions", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "promotion_id"
  end

  add_index "people_promotions", ["person_id"], name: "index_people_promotions_on_person_id", using: :btree
  add_index "people_promotions", ["promotion_id"], name: "index_people_promotions_on_promotion_id", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sectors", ["name"], name: "index_sectors_on_name", unique: true, using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "states", ["name"], name: "index_states_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 128, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "admin",                              default: false
    t.string   "username",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
