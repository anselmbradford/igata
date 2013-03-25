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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130304202833) do

  create_table "accounts", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "stripe_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "dismissed_helpers", :default => [],                 :array => true
    t.string   "username"
    t.string   "slug"
  end

  add_index "accounts", ["slug"], :name => "index_accounts_on_slug"

  create_table "addon_templates", :force => true do |t|
    t.integer  "addon_id"
    t.integer  "template_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "addon_templates", ["addon_id"], :name => "index_addon_templates_on_addon_id"
  add_index "addon_templates", ["template_id"], :name => "index_addon_templates_on_template_id"

  create_table "addons", :force => true do |t|
    t.string   "name",                :null => false
    t.string   "description"
    t.string   "url"
    t.boolean  "beta"
    t.string   "state"
    t.integer  "cents",               :null => false
    t.string   "price_units",         :null => false
    t.boolean  "attachable"
    t.string   "slug"
    t.boolean  "consumes_dyno_hours"
    t.string   "plan_description"
    t.string   "group_description"
    t.boolean  "selective"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "addons", ["name"], :name => "index_addons_on_name", :unique => true

  create_table "identities", :force => true do |t|
    t.string   "uid"
    t.string   "token"
    t.string   "account_type"
    t.integer  "account_id"
    t.string   "reset_token_digest"
    t.string   "remember_token_digest"
    t.string   "type"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "identities", ["remember_token_digest"], :name => "index_identities_on_remember_token"
  add_index "identities", ["reset_token_digest"], :name => "index_identities_on_reset_token"
  add_index "identities", ["uid"], :name => "index_identities_on_username"

  create_table "screenshots", :force => true do |t|
    t.integer  "template_id"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "screenshots", ["template_id"], :name => "index_screenshots_on_template_id"

  create_table "template_demos", :force => true do |t|
    t.integer  "account_id"
    t.integer  "template_id"
    t.string   "web_url"
    t.string   "git_url"
    t.string   "app_name"
    t.string   "state",           :default => "pending"
    t.text     "error_message"
    t.text     "error_backtrace"
    t.datetime "valid_until"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "state_messages",  :default => [],                        :array => true
  end

  add_index "template_demos", ["account_id"], :name => "index_template_demos_on_account_id"
  add_index "template_demos", ["template_id"], :name => "index_template_demos_on_template_id"

  create_table "template_purchases", :force => true do |t|
    t.integer  "account_id"
    t.integer  "template_id"
    t.string   "web_url"
    t.string   "git_url"
    t.string   "app_name"
    t.string   "state",           :default => "pending"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "error_message"
    t.text     "error_backtrace"
    t.string   "purchase_id"
    t.text     "state_messages",  :default => [],                        :array => true
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.decimal  "developer_cost",                      :precision => 19, :scale => 2
    t.string   "uri"
    t.integer  "state",                                                              :default => 1000
    t.text     "config_vars"
    t.string   "post_deploy_processes",                                              :default => [],                   :array => true
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
    t.text     "readme",                                                             :default => ""
    t.string   "git_commit_history",    :limit => 40,                                                                  :array => true
    t.datetime "last_git_action_at"
    t.string   "slug"
  end

  add_index "templates", ["slug"], :name => "index_templates_on_slug"

end
