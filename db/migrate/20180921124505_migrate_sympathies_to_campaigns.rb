class MigrateSympathiesToCampaigns < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          Sympathy.all.each do |sympathy|
            puts sympathy
            campaign = Campaign.new(title: sympathy.title, body: sympathy.title, user_id: sympathy.user_id, views_count: sympathy.views_count, comments_count: sympathy.comments_count, created_at: sympathy.created_at, updated_at: sympathy.updated_at,
              previous_event_id: sympathy.id, template: 'sympathy')
            campaign.remote_cover_image_url = sympathy.cover_image_url if sympathy.read_attribute(:cover_image).present?
            campaign.remote_social_image_url = sympathy.social_image_url if sympathy.read_attribute(:social_image).present?
            campaign.save!
            sympathy.comments.update_all(commentable_type: 'Campaign', commentable_id: campaign.id)
          end
        end
      end

      dir.down do
        transaction do
          execute <<-SQL
            UPDATE comments
               SET commentable_id = (SELECT previous_event_id FROM campaigns WHERE id = commentable_id)
                   , commentable_type = 'Sympathy'
             WHERE commentable_type = 'Campaign'
               AND commentable_id in (SELECT id FROM campaigns WHERE template = 'sympathy')
          SQL
          execute <<-SQL
            DELETE FROM campaigns
             WHERE template = 'sympathy'
          SQL
        end
      end
    end
  end
end
