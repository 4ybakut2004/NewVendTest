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

ActiveRecord::Schema.define(version: 20140316090238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "machines", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "location"
    t.string   "machine_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "machines", ["name"], name: "index_machines_on_name", using: :btree
  add_index "machines", ["uid"], name: "index_machines_on_uid", using: :btree

  create_table "messages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "request_type"
  end

  create_table "request_messages", force: true do |t|
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_id"
  end

  create_table "requests", force: true do |t|
    t.string   "employee"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "machine_id"
    t.string   "request_type", default: "phone"
    t.string   "phone"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
