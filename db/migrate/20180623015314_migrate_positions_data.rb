class MigratePositionsData < ActiveRecord::Migration[5.0]
  def change
    ActiveRecord::Base.transaction do
      ActsAsTaggableOn::Tagging.where('taggable_type': "Agent").where('context': 'positions').each do |tagging|
        tag_name = tagging.tag.name
        position = Position.find_or_create_by(name: tag_name)
        agent = tagging.taggable
        if !agent.positions.exists?(id: position)
          agent.appointments.create!(position: position)
        end
      end
      ActsAsTaggableOn::Tagging.where('taggable_type': "Agency").where('context': 'positions').each do |tagging|
        tag_name = tagging.tag.name
        position = Position.find_or_create_by(name: tag_name)
        agency = tagging.taggable
        if !agency.positions.exists?(id: position)
          agency.positions << position
          agency.save!
        end
      end
    end
  end
end
