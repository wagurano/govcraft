class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC"  do |t|
      t.references "user"
      t.references "opinion", null: false, index: true
      t.text     "body"
      t.string   "choice"
      t.string   "writer_name"
      t.string   "writer_email"
      t.integer  "reports_count", default: 0
      t.integer  "likes_count", default: 0
      t.integer  "anonymous_likes_count", default: 0
      t.boolean  "sent_email", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            INSERT
              INTO notes(user_id, opinion_id, body, choice, writer_name, writer_email, reports_count, likes_count, anonymous_likes_count, created_at, updated_at)
            SELECT user_id, commentable_id, body, choice, commenter_name, commenter_email, reports_count, likes_count, anonymous_likes_count, created_at, updated_at
              FROM comments
             WHERE commentable_type = 'Opinion'
          SQL

          execute <<-SQL
            DELETE
              FROM comments
             WHERE commentable_type = 'Opinion'
          SQL
        end
      end
    end
  end
end
