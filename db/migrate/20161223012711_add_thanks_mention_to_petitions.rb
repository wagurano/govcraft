class AddThanksMentionToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :thanks_mention, :text
  end
end
