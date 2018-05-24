class AddSpecialSlugToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :special_slug, :string, index: true
  end
end
