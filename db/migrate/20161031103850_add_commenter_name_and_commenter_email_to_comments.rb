class AddCommenterNameAndCommenterEmailToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :commenter_name, :string, null: true
    add_column :comments, :commenter_email, :string, null: true
  end
end
