class AddTwitterToSpeakers < ActiveRecord::Migration[5.0]
  def change
    add_column :speakers, :twitter, :string
  end
end
