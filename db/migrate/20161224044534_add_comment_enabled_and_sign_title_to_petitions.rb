class AddCommentEnabledAndSignTitleToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :comment_enabled, :boolean, default: true
    add_column :petitions, :sign_title, :string
  end
end
