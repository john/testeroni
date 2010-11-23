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

ActiveRecord::Schema.define(:version => 20101117044711) do

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.integer  "user_id"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "choices", :force => true do |t|
    t.integer  "question_id"
    t.string   "name"
    t.string   "description"
    t.string   "explanation"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choices", ["question_id"], :name => "index_choices_on_question_id"

  create_table "questions", :force => true do |t|
    t.integer  "test_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.string   "explanation"
    t.integer  "kind"
    t.integer  "correct_response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["test_id"], :name => "index_questions_on_test_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "responses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "test_id"
    t.integer  "question_id"
    t.integer  "choice_id"
    t.integer  "taking_id"
    t.boolean  "answer"
    t.boolean  "correct"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["choice_id"], :name => "index_responses_on_choice_id"
  add_index "responses", ["question_id"], :name => "index_responses_on_question_id"
  add_index "responses", ["test_id"], :name => "index_responses_on_test_id"
  add_index "responses", ["user_id"], :name => "index_responses_on_user_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "takings", :force => true do |t|
    t.integer  "test_id"
    t.integer  "user_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "takings", ["test_id"], :name => "index_takings_on_test_id"
  add_index "takings", ["user_id"], :name => "index_takings_on_user_id"

  create_table "tests", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tests", ["name"], :name => "index_tests_on_name"
  add_index "tests", ["user_id"], :name => "index_tests_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.boolean  "email_list"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "test_id"
    t.integer  "question_id"
    t.string   "name"
    t.string   "description"
    t.string   "provider"
    t.string   "url"
    t.string   "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["question_id"], :name => "index_videos_on_question_id"
  add_index "videos", ["test_id"], :name => "index_videos_on_test_id"

end
