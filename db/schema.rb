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

ActiveRecord::Schema.define(:version => 20120927043415) do

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "leagues", ["name"], :name => "index_leagues_on_name", :unique => true

  create_table "matchups", :force => true do |t|
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.integer  "week"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "league_id"
  end

  add_index "matchups", ["league_id"], :name => "index_matchups_on_league_id"
  add_index "matchups", ["team1_id", "team2_id"], :name => "index_matchups_on_team1_id_and_team2_id", :unique => true
  add_index "matchups", ["team1_id"], :name => "index_matchups_on_team1_id"
  add_index "matchups", ["team2_id"], :name => "index_matchups_on_team2_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "owner"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "league_id"
  end

  add_index "teams", ["league_id"], :name => "index_teams_on_league_id"

end
