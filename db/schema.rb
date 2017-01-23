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

ActiveRecord::Schema.define(version: 20170123020912) do

  create_table "agendas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.text     "problem",               limit: 65535
    t.text     "solution",              limit: 65535
    t.text     "memo",                  limit: 65535
    t.string   "image"
    t.integer  "comments_count",                      default: 0
    t.integer  "likes_count",                         default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "outline"
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["user_id"], name: "index_agendas_on_user_id", using: :btree
  end

  create_table "archive_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.date     "date"
    t.string   "time"
    t.integer  "user_id",                                         null: false
    t.integer  "archive_id",                                      null: false
    t.integer  "comments_count",                      default: 0
    t.integer  "likes_count",                         default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "image"
    t.string   "source_url"
    t.string   "media_url"
    t.string   "media_credit"
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["archive_id"], name: "index_archive_documents_on_archive_id", using: :btree
    t.index ["user_id"], name: "index_archive_documents_on_user_id", using: :btree
  end

  create_table "archives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.string   "image"
    t.integer  "user_id",                                         null: false
    t.integer  "comments_count",                      default: 0
    t.integer  "likes_count",                         default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "banner_image"
    t.string   "banner_url"
    t.integer  "anonymous_likes_count",               default: 0
    t.integer  "timeline_initial_zoom"
    t.index ["user_id"], name: "index_archives_on_user_id", using: :btree
  end

  create_table "articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.text     "url",                   limit: 65535
    t.text     "body",                  limit: 65535
    t.string   "title"
    t.text     "desc",                  limit: 65535
    t.text     "metadata",              limit: 65535
    t.string   "image"
    t.string   "page_type"
    t.string   "crawling_status"
    t.datetime "crawled_at"
    t.string   "site_name"
    t.integer  "image_height",                        default: 0
    t.integer  "image_width",                         default: 0
    t.integer  "user_id"
    t.integer  "likes_count",                         default: 0
    t.integer  "comments_count",                      default: 0
    t.integer  "anonymous_likes_count",               default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "hot_score",                           default: 0
    t.string   "hot_scored_datestamp"
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "candidates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name"
    t.text     "body",        limit: 65535
    t.string   "image"
    t.integer  "election_id",               null: false
    t.integer  "user_id",                   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["election_id"], name: "index_candidates_on_election_id", using: :btree
    t.index ["user_id"], name: "index_candidates_on_user_id", using: :btree
  end

  create_table "citizen2017_speeches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string  "title"
    t.integer "citizen2017_id"
    t.string  "video_url"
    t.integer "speech_id"
    t.index ["speech_id"], name: "index_citizen2017_speeches_on_speech_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id",                                  null: false
    t.text     "body",                  limit: 65535
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "choice"
    t.string   "commenter_name"
    t.string   "commenter_email"
    t.integer  "reports_count",                       default: 0
    t.integer  "likes_count",                         default: 0
    t.string   "image"
    t.float    "latitude",              limit: 24
    t.float    "longitude",             limit: 24
    t.string   "full_street_address"
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "discussions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "likes_count",                         default: 0
    t.integer  "views_count",                         default: 0
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["project_id"], name: "index_discussions_on_project_id", using: :btree
    t.index ["user_id"], name: "index_discussions_on_user_id", using: :btree
  end

  create_table "elections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",            limit: 65535
    t.string   "image"
    t.integer  "user_id",                       null: false
    t.integer  "project_id"
    t.datetime "registered_from",               null: false
    t.datetime "registered_to",                 null: false
    t.datetime "voted_from",                    null: false
    t.datetime "voted_to",                      null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["project_id"], name: "index_elections_on_project_id", using: :btree
    t.index ["user_id"], name: "index_elections_on_user_id", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "body",           limit: 65535
    t.string   "image"
    t.integer  "user_id"
    t.integer  "comments_count",               default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "project_id"
    t.string   "template"
    t.index ["project_id"], name: "index_events_on_project_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id",    null: false
    t.integer  "survey_id",  null: false
    t.integer  "option_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_feedbacks_on_option_id", using: :btree
    t.index ["survey_id"], name: "index_feedbacks_on_survey_id", using: :btree
    t.index ["user_id", "survey_id"], name: "index_feedbacks_on_user_id_and_survey_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_feedbacks_on_user_id", using: :btree
  end

  create_table "following_issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "user_id"], name: "index_following_issues_on_issue_id_and_user_id", unique: true, using: :btree
    t.index ["issue_id"], name: "index_following_issues_on_issue_id", using: :btree
    t.index ["user_id"], name: "index_following_issues_on_user_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.integer  "following_issues_count", default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["title"], name: "index_issues_on_title", unique: true, using: :btree
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id",      null: false
    t.string   "likable_type"
    t.integer  "likable_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "memorials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "likes_count",                         default: 0
    t.integer  "comments_count",                      default: 0
    t.string   "image"
    t.string   "url"
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["user_id"], name: "index_memorials_on_user_id", using: :btree
  end

  create_table "options", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "survey_id",                                 null: false
    t.text     "body",            limit: 65535
    t.integer  "feedbacks_count",               default: 0, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["survey_id"], name: "index_options_on_survey_id", using: :btree
  end

  create_table "participations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "user_id",    null: false
    t.integer  "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_participations_on_project_id", using: :btree
    t.index ["user_id", "project_id"], name: "index_participations_on_user_id_and_project_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_participations_on_user_id", using: :btree
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name",                     null: false
    t.text     "body",       limit: 65535
    t.string   "image"
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_people_on_user_id", using: :btree
  end

  create_table "petitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "likes_count",                         default: 0
    t.integer  "signs_goal_count",                    default: 1000
    t.integer  "signs_count",                         default: 0
    t.integer  "views_count",                         default: 0
    t.string   "cover_image"
    t.integer  "anonymous_likes_count",               default: 0
    t.text     "thanks_mention",        limit: 65535
    t.boolean  "comment_enabled",                     default: true
    t.string   "sign_title"
    t.index ["project_id"], name: "index_petitions_on_project_id", using: :btree
    t.index ["user_id"], name: "index_petitions_on_user_id", using: :btree
  end

  create_table "players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "person_id",                       null: false
    t.integer  "user_id",                         null: false
    t.integer  "race_id",                         null: false
    t.integer  "thumbs_up_count",     default: 0
    t.integer  "thumbs_down_count",   default: 0
    t.integer  "thumbs_middle_count", default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["person_id"], name: "index_players_on_person_id", using: :btree
    t.index ["race_id", "person_id"], name: "index_players_on_race_id_and_person_id", unique: true, using: :btree
    t.index ["race_id"], name: "index_players_on_race_id", using: :btree
    t.index ["user_id"], name: "index_players_on_user_id", using: :btree
  end

  create_table "polls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "likes_count",                         default: 0
    t.integer  "votes_count",                         default: 0
    t.integer  "agrees_count",                        default: 0
    t.integer  "disagrees_count",                     default: 0
    t.integer  "views_count",                         default: 0
    t.string   "social_card"
    t.string   "cover_image"
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["project_id"], name: "index_polls_on_project_id", using: :btree
    t.index ["user_id"], name: "index_polls_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",               limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "views_count",                      default: 0
    t.string   "image"
    t.boolean  "discussion_enabled",               default: true
    t.boolean  "petition_enabled",                 default: true
    t.boolean  "poll_enabled",                     default: true
    t.boolean  "wiki_enabled",                     default: true
    t.string   "discussion_title"
    t.string   "poll_title"
    t.string   "petition_title"
    t.string   "wiki_title"
    t.string   "slug",                                            null: false
    t.boolean  "survey_enabled",                   default: true
    t.string   "survey_title"
    t.string   "subtitle"
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "races", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "title",                    null: false
    t.text     "body",       limit: 65535
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_races_on_user_id", using: :btree
  end

  create_table "redactor2_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assetable_type", "assetable_id"], name: "idx_redactor2_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_redactor2_assetable_type", using: :btree
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "reportable_type"
    t.integer  "reportable_id",   null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["reportable_id", "reportable_type", "user_id"], name: "index_reports_on_reportable_id_and_reportable_type_and_user_id", unique: true, using: :btree
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id", using: :btree
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "signs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.integer  "petition_id",                                         null: false
    t.text     "body",                  limit: 65535
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "signer_name"
    t.string   "signer_email"
    t.integer  "reports_count",                       default: 0
    t.boolean  "extra_29_confirm_join",               default: false
    t.index ["petition_id"], name: "index_signs_on_petition_id", using: :btree
    t.index ["user_id", "petition_id"], name: "index_signs_on_user_id_and_petition_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_signs_on_user_id", using: :btree
  end

  create_table "speeches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title",                                 null: false
    t.string   "video_url",                             null: false
    t.integer  "event_id",                              null: false
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "likes_count",           default: 0
    t.integer  "anonymous_likes_count", default: 0
    t.integer  "cached_view_count",     default: 0
    t.datetime "view_count_cached_at"
    t.boolean  "is_expired_view_count", default: false
    t.index ["event_id"], name: "index_speeches_on_event_id", using: :btree
    t.index ["user_id"], name: "index_speeches_on_user_id", using: :btree
  end

  create_table "surveys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id",                                         null: false
    t.integer  "project_id"
    t.integer  "likes_count",                         default: 0
    t.integer  "anonymous_likes_count",               default: 0
    t.integer  "feedbacks_count",                     default: 0, null: false
    t.integer  "views_count",                         default: 0, null: false
    t.integer  "duration",                            default: 0, null: false
    t.string   "cover_image"
    t.string   "social_card"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["project_id"], name: "index_surveys_on_project_id", using: :btree
    t.index ["user_id"], name: "index_surveys_on_user_id", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "thumb_stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "race_id",                       null: false
    t.integer  "player_id",                     null: false
    t.integer  "thumbs_up_count",   default: 0
    t.integer  "thumbs_down_count", default: 0
    t.date     "stated_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["player_id"], name: "index_thumb_stats_on_player_id", using: :btree
    t.index ["race_id"], name: "index_thumb_stats_on_race_id", using: :btree
  end

  create_table "thumbs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.string   "thumbable_type"
    t.integer  "thumbable_id"
    t.string   "direction",      null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["thumbable_type", "thumbable_id"], name: "index_thumbs_on_thumbable_type_and_thumbable_id", using: :btree
    t.index ["user_id", "thumbable_id", "thumbable_type"], name: "index_thumbs_on_user_id_and_thumbable_id_and_thumbable_type", unique: true, using: :btree
    t.index ["user_id"], name: "index_thumbs_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "email"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "image"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.text     "description",            limit: 65535
    t.boolean  "enable_mailing",                       default: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  create_table "votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "user_id"
    t.integer  "poll_id",    null: false
    t.string   "choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_votes_on_poll_id", using: :btree
    t.index ["user_id", "poll_id"], name: "index_votes_on_user_id_and_poll_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
  end

  create_table "wiki_revisions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.integer  "wiki_id",                  null: false
    t.integer  "user_id",                  null: false
    t.text     "body",       limit: 65535
    t.text     "note",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_wiki_revisions_on_user_id", using: :btree
    t.index ["wiki_id"], name: "index_wiki_revisions_on_wiki_id", using: :btree
  end

  create_table "wikis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
    t.string   "title"
    t.text     "body",                  limit: 65535
    t.integer  "user_id",                                         null: false
    t.integer  "project_id",                                      null: false
    t.integer  "views_count",                         default: 0
    t.integer  "comments_count",                      default: 0
    t.integer  "likes_count",                         default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "anonymous_likes_count",               default: 0
    t.index ["project_id"], name: "index_wikis_on_project_id", using: :btree
    t.index ["user_id"], name: "index_wikis_on_user_id", using: :btree
  end

  add_foreign_key "events", "users"
end
