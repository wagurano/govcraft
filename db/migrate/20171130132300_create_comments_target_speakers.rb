class CreateCommentsTargetSpeakers < ActiveRecord::Migration[5.0]
  def change
    create_table :comments_target_speakers do |t|
      t.belongs_to :comment, index: true
      t.belongs_to :speaker, index: true
      t.timestamps null: false
    end
    add_index :comments_target_speakers, [:comment_id, :speaker_id], unique: true, name: 'comments_target_speakers_uk'

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            INSERT INTO comments_target_speakers
                        (comment_id, speaker_id, created_at, updated_at)
                 SELECT comments.id, comments.target_speaker_id, now(), now()
                   FROM comments
                  WHERE comments.target_speaker_id <> null
          SQL
        end
      end

      dir.down do
      end
    end
  end
end
