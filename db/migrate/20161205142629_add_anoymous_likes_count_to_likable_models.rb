class AddAnoymousLikesCountToLikableModels < ActiveRecord::Migration[5.0]
  def change
    %i(agendas archive_documents archives comments discussions memorials petitions polls wikis).each do |model|
      add_column model, :anonymous_likes_count, :integer, default: 0
    end
  end
end
