# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_06_27_160636) do
  create_table "startup_tips", force: :cascade do |t|
    t.string "topic"
    t.string "tool"
    t.text "strategy"
    t.text "case_study"
    t.string "sentiment"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic"], name: "index_startup_tips_on_topic"
  end

  create_table "videos", force: :cascade do |t|
    t.integer "startup_tip_id", null: false
    t.string "script"
    t.string "video_path"
    t.string "thumbnail_path"
    t.string "youtube_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["startup_tip_id"], name: "index_videos_on_startup_tip_id"
  end

  add_foreign_key "videos", "startup_tips"
end
