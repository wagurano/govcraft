class AddSocialCardToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :social_card, :string
  end
end
