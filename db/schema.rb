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

ActiveRecord::Schema.define(version: 20131025222429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: true do |t|
    t.text     "body"
    t.string   "github_url"
    t.string   "labels"
    t.string   "lighthouse_url"
    t.string   "milestone"
    t.integer  "milestone_id"
    t.string   "name"
    t.string   "source"
    t.string   "title"
    t.integer  "repo_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["name", "source", "user_id"], name: "index_branches_on_name_and_source_and_user_id", unique: true, using: :btree
  add_index "branches", ["name"], name: "index_branches_on_name", using: :btree
  add_index "branches", ["repo_id"], name: "index_branches_on_repo_id", using: :btree
  add_index "branches", ["source"], name: "index_branches_on_source", using: :btree
  add_index "branches", ["user_id"], name: "index_branches_on_user_id", using: :btree

  create_table "github_projects", force: true do |t|
    t.string   "owner"
    t.string   "repo"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "github_projects", ["user_id"], name: "index_github_projects_on_user_id", using: :btree

  create_table "lighthouse_tickets", force: true do |t|
    t.string   "service"
    t.integer  "number"
    t.string   "status"
    t.string   "title"
    t.string   "url",                         limit: 256
    t.string   "body",                        limit: 20480
    t.integer  "assigned_lighthouse_user_id"
    t.integer  "lighthouse_user_id"
    t.datetime "ticket_created_at"
    t.datetime "ticket_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lighthouse_tickets", ["assigned_lighthouse_user_id"], name: "index_lighthouse_tickets_on_assigned_lighthouse_user_id", using: :btree
  add_index "lighthouse_tickets", ["lighthouse_user_id"], name: "index_lighthouse_tickets_on_lighthouse_user_id", using: :btree
  add_index "lighthouse_tickets", ["number"], name: "index_lighthouse_tickets_on_number", using: :btree

  create_table "lighthouse_users", force: true do |t|
    t.string   "namespace"
    t.string   "token"
    t.integer  "lighthouse_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lighthouse_users", ["lighthouse_id"], name: "index_lighthouse_users_on_lighthouse_id", using: :btree
  add_index "lighthouse_users", ["namespace"], name: "index_lighthouse_users_on_namespace", using: :btree
  add_index "lighthouse_users", ["token"], name: "index_lighthouse_users_on_token", using: :btree
  add_index "lighthouse_users", ["user_id"], name: "index_lighthouse_users_on_user_id", using: :btree

  create_table "pull_requests", force: true do |t|
    t.integer  "number"
    t.string   "status"
    t.string   "url"
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pull_requests", ["ticket_id"], name: "index_pull_requests_on_ticket_id", using: :btree
  add_index "pull_requests", ["user_id"], name: "index_pull_requests_on_user_id", using: :btree

  create_table "repos", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repos", ["name", "user_id"], name: "index_repos_on_name_and_user_id", unique: true, using: :btree
  add_index "repos", ["name"], name: "index_repos_on_name", using: :btree
  add_index "repos", ["owner_id"], name: "index_repos_on_owner_id", using: :btree
  add_index "repos", ["user_id"], name: "index_repos_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "gitcycle"
    t.string   "github"
    t.string   "gravatar"
    t.string   "login"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["gitcycle"], name: "index_users_on_gitcycle", unique: true, using: :btree
  add_index "users", ["github", "login"], name: "index_users_on_github_and_login", unique: true, using: :btree
  add_index "users", ["github"], name: "index_users_on_github", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
