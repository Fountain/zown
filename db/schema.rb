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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120714062844) do

  create_table "captures", :force => true do |t|
    t.integer  "game_id"
    t.integer  "runner_id"
    t.integer  "node_id"
    t.datetime "captured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.integer  "code"
  end

  create_table "clusters", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clusters_nodes", :id => false, :force => true do |t|
    t.integer "node_id"
    t.integer "cluster_id"
  end

  create_table "codes", :force => true do |t|
    t.string   "contents"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "games", :force => true do |t|
    t.integer  "creator_id"
    t.boolean  "security"
    t.integer  "capture_limit"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time_limit"
    t.datetime "end_time"
  end

  create_table "nodes", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "code_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  create_table "runners", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile_number"
  end

  create_table "runners_teams", :id => false, :force => true do |t|
    t.integer "runner_id"
    t.integer "team_id"
  end

  create_table "teams", :force => true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "aggregate_time"
  end

end
