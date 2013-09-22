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

ActiveRecord::Schema.define(version: 20130922042316) do

  create_table "charities", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.integer  "phone"
    t.string   "email",      limit: 40
    t.string   "wishlist"
    t.integer  "donations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charities", ["name"], name: "index_charities_on_name", unique: true

  create_table "donations", force: true do |t|
    t.integer  "money"
    t.integer  "User_id"
    t.integer  "Charity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donations", ["Charity_id"], name: "index_donations_on_Charity_id"
  add_index "donations", ["User_id"], name: "index_donations_on_User_id"

  create_table "orders", force: true do |t|
    t.integer  "order_id"
    t.string   "asin"
    t.integer  "date"
    t.integer  "User_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["User_id"], name: "index_orders_on_User_id"
  add_index "orders", ["order_id"], name: "index_orders_on_order_id"

  create_table "users", force: true do |t|
    t.string   "email",      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email"

end
