class AddOrganizationToArchives < ActiveRecord::Migration[5.0]
  def change
      add_reference :archives, :organization, index: true, null: true
  end
end
