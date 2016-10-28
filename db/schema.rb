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

ActiveRecord::Schema.define(version: 20161028233822) do

  create_table "agendas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "user_id"
    t.text     "problem",        limit: 65535
    t.text     "solution",       limit: 65535
    t.text     "memo",           limit: 65535
    t.string   "image"
    t.integer  "comments_count",               default: 0
    t.integer  "likes_count",                  default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "outline"
    t.index ["user_id"], name: "index_agendas_on_user_id", using: :btree
  end

  create_table "archive_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.text     "body",           limit: 65535
    t.date     "date"
    t.string   "time"
    t.integer  "user_id",                                  null: false
    t.integer  "archive_id",                               null: false
    t.integer  "comments_count",               default: 0
    t.integer  "likes_count",                  default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["archive_id"], name: "index_archive_documents_on_archive_id", using: :btree
    t.index ["user_id"], name: "index_archive_documents_on_user_id", using: :btree
  end

  create_table "archives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.text     "body",           limit: 65535
    t.string   "image"
    t.integer  "user_id",                                  null: false
    t.integer  "comments_count",               default: 0
    t.integer  "likes_count",                  default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["user_id"], name: "index_archives_on_user_id", using: :btree
  end

  create_table "campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.text     "body",       limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "user_id",                        null: false
    t.string   "commentable_type",               null: false
    t.integer  "commentable_id",                 null: false
    t.text     "body",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "discussions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.text     "body",        limit: 65535
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "likes_count",               default: 0
    t.index ["campaign_id"], name: "index_discussions_on_campaign_id", using: :btree
    t.index ["user_id"], name: "index_discussions_on_user_id", using: :btree
  end

  create_table "following_issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "user_id"], name: "index_following_issues_on_issue_id_and_user_id", unique: true, using: :btree
    t.index ["issue_id"], name: "index_following_issues_on_issue_id", using: :btree
    t.index ["user_id"], name: "index_following_issues_on_user_id", using: :btree
  end

  create_table "issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title",                              null: false
    t.integer  "following_issues_count", default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["title"], name: "index_issues_on_title", unique: true, using: :btree
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "user_id",      null: false
    t.string   "likable_type", null: false
    t.integer  "likable_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "memorials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.text     "body",        limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "likes_count",               default: 0
    t.index ["user_id"], name: "index_memorials_on_user_id", using: :btree
  end

  create_table "petitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.text     "body",             limit: 65535
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "likes_count",                    default: 0
    t.integer  "signs_goal_count",               default: 1000
    t.integer  "signs_count"
    t.index ["campaign_id"], name: "index_petitions_on_campaign_id", using: :btree
    t.index ["user_id"], name: "index_petitions_on_user_id", using: :btree
  end

  create_table "polls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.text     "body",            limit: 65535
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "likes_count",                   default: 0
    t.integer  "votes_count",                   default: 0
    t.integer  "agrees_count",                  default: 0
    t.integer  "disagrees_count",               default: 0
    t.index ["campaign_id"], name: "index_polls_on_campaign_id", using: :btree
    t.index ["user_id"], name: "index_polls_on_user_id", using: :btree
  end

  create_table "signs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "user_id",                   null: false
    t.integer  "petition_id",               null: false
    t.text     "body",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["petition_id"], name: "index_signs_on_petition_id", using: :btree
    t.index ["user_id", "petition_id"], name: "index_signs_on_user_id_and_petition_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_signs_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "email",               default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider",                         null: false
    t.string   "uid",                              null: false
    t.string   "nickname"
    t.string   "image"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  end

  create_table "votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "user_id",    null: false
    t.integer  "poll_id",    null: false
    t.string   "choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_votes_on_poll_id", using: :btree
    t.index ["user_id", "poll_id"], name: "index_votes_on_user_id_and_poll_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
  end

end
