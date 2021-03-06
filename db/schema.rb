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

ActiveRecord::Schema.define(version: 20150616151216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "category"
    t.string   "title"
    t.text     "summary"
    t.text     "content"
    t.string   "url"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "has_recommendation", default: false
    t.string   "img"
    t.text     "content_html"
  end

  add_index "articles", ["category", "url"], name: "index_articles_on_category_and_url", unique: true, using: :btree

  create_table "recommended_articles", force: :cascade do |t|
    t.integer  "article_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "similar_article_id"
  end

  add_index "recommended_articles", ["article_id"], name: "index_recommended_articles_on_article_id", using: :btree

  create_table "similar_articles", force: :cascade do |t|
    t.integer  "category"
    t.string   "title"
    t.text     "summary"
    t.text     "content"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "similar_articles", ["category", "url"], name: "index_similar_articles_on_category_and_url", unique: true, using: :btree

end
