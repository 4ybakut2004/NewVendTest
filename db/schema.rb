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

ActiveRecord::Schema.define(version: 20140408073207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "message_tasks", force: true do |t|
    t.integer  "message_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "request_tasks", force: true do |t|
    t.integer  "assigner_id"
    t.integer  "executor_id"
    t.integer  "auditor_id"
    t.string   "description"
    t.integer  "request_message_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "creation_date"
    t.datetime "execution_date"
    t.datetime "audition_date"
    t.datetime "deadline_date"
  end

  create_table "requests", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "machine_id"
    t.string   "request_type", default: "phone"
    t.string   "phone"
    t.integer  "registrar_id"
    t.integer  "solver_id"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deadline",   default: 5
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.integer  "employee_id"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
