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

ActiveRecord::Schema.define(version: 20140630101227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attributes", force: true do |t|
    t.string   "name"
    t.string   "attribute_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attributes", ["name"], name: "index_attributes_on_name", unique: true, using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "employees", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "phone"
    t.integer  "next_sms_code",      default: 0
    t.boolean  "first_code_is_free", default: true
  end

  add_index "employees", ["name"], name: "index_employees_on_name", unique: true, using: :btree

  create_table "holes", force: true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holes", ["code"], name: "index_holes_on_code", using: :btree

  create_table "machines", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sales_location_id"
    t.integer  "model_id"
    t.string   "machine_key"
    t.string   "guid"
    t.string   "location"
    t.string   "code"
    t.string   "external_code"
  end

  add_index "machines", ["name"], name: "index_machines_on_name", using: :btree

  create_table "message_attributes", force: true do |t|
    t.integer  "message_id"
    t.integer  "attribute_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_attributes", ["message_id", "attribute_id"], name: "index_message_attributes_on_message_id_and_attribute_id", unique: true, using: :btree

  create_table "message_tasks", force: true do |t|
    t.integer  "message_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_tasks", ["message_id", "task_id"], name: "index_message_tasks_on_message_id_and_task_id", unique: true, using: :btree

  create_table "messages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "messages", ["name"], name: "index_messages_on_name", unique: true, using: :btree

  create_table "models", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "models", ["name"], name: "index_models_on_name", unique: true, using: :btree

  create_table "motors", force: true do |t|
    t.string   "name"
    t.float    "left_spiral_position"
    t.float    "right_spiral_position"
    t.float    "left_bound_offset"
    t.float    "right_bound_offset"
    t.integer  "mount_priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "motors", ["name"], name: "index_motors_on_name", unique: true, using: :btree

  create_table "new_vend_settings", force: true do |t|
    t.integer  "read_confirm_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "host_name"
    t.string   "phone_host_name"
  end

  create_table "request_attributes", force: true do |t|
    t.integer  "request_message_id"
    t.integer  "attribute_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "request_attributes", ["attribute_id", "request_message_id"], name: "index_request_attributes_on_attribute_id_and_request_message_id", unique: true, using: :btree

  create_table "request_messages", force: true do |t|
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_id"
  end

  add_index "request_messages", ["message_id", "request_id"], name: "index_request_messages_on_message_id_and_request_id", using: :btree

  create_table "request_tasks", force: true do |t|
    t.integer  "assigner_id"
    t.integer  "executor_id"
    t.integer  "auditor_id"
    t.text     "description"
    t.integer  "request_message_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "creation_date"
    t.datetime "execution_date"
    t.datetime "audition_date"
    t.datetime "deadline_date"
    t.text     "registrar_description"
    t.text     "assigner_description"
    t.text     "executor_description"
    t.text     "auditor_description"
    t.datetime "audition_entering_date"
    t.boolean  "is_read_by_assigner",    default: false
    t.boolean  "is_read_by_executor",    default: false
    t.boolean  "is_read_by_auditor",     default: false
    t.datetime "email_to_assigner_date"
    t.datetime "email_to_executor_date"
    t.datetime "email_to_auditor_date"
    t.integer  "assigner_sms_code"
    t.integer  "executor_sms_code"
    t.integer  "auditor_sms_code"
  end

  create_table "request_type_messages", force: true do |t|
    t.integer  "request_type_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "request_type_messages", ["message_id", "request_type_id"], name: "index_request_type_messages_on_message_id_and_request_type_id", unique: true, using: :btree

  create_table "request_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "request_types", ["name"], name: "index_request_types_on_name", unique: true, using: :btree

  create_table "requests", force: true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "machine_id"
    t.string   "phone"
    t.integer  "registrar_id"
    t.integer  "request_type_id", default: 4
  end

  create_table "sales_locations", force: true do |t|
    t.string   "name"
    t.integer  "vendor_id"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales_locations", ["name"], name: "index_sales_locations_on_name", unique: true, using: :btree

  create_table "shelves", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spirals", force: true do |t|
    t.string   "name"
    t.string   "direction"
    t.integer  "mount_priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spirals", ["name"], name: "index_spirals_on_name", unique: true, using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deadline",   default: 5
    t.integer  "solver_id"
  end

  add_index "tasks", ["name"], name: "index_tasks_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.integer  "employee_id"
    t.string   "menu_position",   default: "shown"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendors", ["name"], name: "index_vendors_on_name", unique: true, using: :btree

end
