# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2011_01_06_195117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "user_id"
    t.integer "verb"
    t.integer "object_type"
    t.integer "object_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_id"], name: "index_activities_on_object_id"
    t.index ["object_type"], name: "index_activities_on_object_type"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "choices", force: :cascade do |t|
    t.integer "question_id"
    t.string "name"
    t.string "simple_name"
    t.string "description"
    t.integer "status", limit: 2
    t.string "explanation"
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "tst_id", default: 0
    t.integer "question_id", default: 0
    t.integer "commentable_id", default: 0
    t.string "commentable_type", limit: 15, default: ""
    t.string "title", default: ""
    t.text "body", default: ""
    t.string "subject", default: ""
    t.integer "user_id", default: 0, null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name", default: ""
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "user_id"
    t.integer "follow_type"
    t.integer "follow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follow_id"], name: "index_follows_on_follow_id"
    t.index ["follow_type"], name: "index_follows_on_follow_type"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "tst_id"
    t.integer "user_id"
    t.string "name"
    t.string "description"
    t.string "hint"
    t.integer "status", limit: 2
    t.string "image_url"
    t.string "explanation"
    t.integer "kind"
    t.integer "correct_response"
    t.integer "pause_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_questions_on_slug", unique: true
    t.index ["tst_id"], name: "index_questions_on_tst_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tst_id"
    t.integer "question_id"
    t.integer "choice_id"
    t.integer "take_id"
    t.boolean "answer"
    t.boolean "correct"
    t.string "name"
    t.string "description"
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["choice_id"], name: "index_responses_on_choice_id"
    t.index ["question_id"], name: "index_responses_on_question_id"
    t.index ["tst_id"], name: "index_responses_on_tst_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "takes", force: :cascade do |t|
    t.integer "tst_id"
    t.integer "user_id"
    t.integer "questions_answered", default: 0
    t.integer "questions_correct", default: 0
    t.string "question_order"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tst_id"], name: "index_takes_on_tst_id"
    t.index ["user_id"], name: "index_takes_on_user_id"
  end

  create_table "tsts", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "description"
    t.integer "status", limit: 2
    t.integer "contributors", limit: 2
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["name"], name: "index_tsts_on_name"
    t.index ["slug"], name: "index_tsts_on_slug", unique: true
    t.index ["user_id"], name: "index_tsts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "auth_service"
    t.string "auth_id"
    t.string "name"
    t.integer "utc_offset"
    t.string "lang"
    t.boolean "email_list"
    t.integer "status"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.integer "tst_id"
    t.integer "question_id"
    t.string "name"
    t.string "description"
    t.integer "status", limit: 2
    t.string "provider"
    t.string "url"
    t.string "provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_videos_on_question_id"
    t.index ["tst_id"], name: "index_videos_on_tst_id"
  end

  create_table "votes", force: :cascade do |t|
    t.boolean "vote", default: false
    t.string "voteable_type", null: false
    t.bigint "voteable_id", null: false
    t.string "voter_type"
    t.bigint "voter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voteable_id", "voteable_type"], name: "fk_voteables"
    t.index ["voteable_type", "voteable_id"], name: "index_votes_on_voteable_type_and_voteable_id"
    t.index ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "uniq_one_vote_only", unique: true
    t.index ["voter_id", "voter_type"], name: "fk_voters"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

end
