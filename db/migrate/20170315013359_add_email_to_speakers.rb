class AddEmailToSpeakers < ActiveRecord::Migration[5.0]
  def change
    add_column :speakers, :email, :string
  end
end
