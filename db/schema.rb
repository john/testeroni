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

ActiveRecord::Schema.define(:version => 20110106002814) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "verb"
    t.string   "object_type"
    t.integer  "object_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", :force => true do |t|
    t.integer  "question_id"
    t.string   "name"
    t.string   "simple_name"
    t.string   "description"
    t.integer  "status",      :limit => 1
    t.string   "explanation"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choices", ["question_id"], :name => "index_choices_on_question_id"

  create_table "comments", :force => true do |t|
    t.integer  "test_id",                        :default => 0
    t.integer  "question_id",                    :default => 0
    t.integer  "commentable_id",                 :default => 0
    t.string   "commentable_type", :limit => 15, :default => ""
    t.string   "title",                          :default => ""
    t.text     "body"
    t.string   "subject",                        :default => ""
    t.integer  "user_id",                        :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                       :default => ""
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "tst_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.integer  "status",           :limit => 1
    t.string   "image_url"
    t.string   "explanation"
    t.integer  "kind"
    t.integer  "correct_response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["tst_id"], :name => "index_questions_on_tst_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "responses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tst_id"
    t.integer  "question_id"
    t.integer  "choice_id"
    t.integer  "take_id"
    t.boolean  "answer"
    t.boolean  "correct"
    t.string   "name"
    t.string   "description"
    t.integer  "status",      :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["choice_id"], :name => "index_responses_on_choice_id"
  add_index "responses", ["question_id"], :name => "index_responses_on_question_id"
  add_index "responses", ["tst_id"], :name => "index_responses_on_tst_id"
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

  create_table "takes", :force => true do |t|
    t.integer  "tst_id"
    t.integer  "user_id"
    t.integer  "questions_answered",              :default => 0
    t.integer  "questions_correct",               :default => 0
    t.string   "question_order"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "status",             :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "takes", ["tst_id"], :name => "index_takes_on_tst_id"
  add_index "takes", ["user_id"], :name => "index_takes_on_user_id"

  create_table "tsts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.integer  "status",       :limit => 1
    t.integer  "contributors", :limit => 1
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tsts", ["name"], :name => "index_tsts_on_name"
  add_index "tsts", ["user_id"], :name => "index_tsts_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "auth_service"
    t.string   "auth_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.integer  "utc_offset"
    t.string   "lang"
    t.boolean  "email_list"
    t.integer  "status",               :limit => 3
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
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
    t.integer  "tst_id"
    t.integer  "question_id"
    t.string   "name"
    t.string   "description"
    t.integer  "status",      :limit => 1
    t.string   "provider"
    t.string   "url"
    t.string   "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["question_id"], :name => "index_videos_on_question_id"
  add_index "videos", ["tst_id"], :name => "index_videos_on_tst_id"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "uniq_one_vote_only", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

end
