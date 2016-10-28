class AddChoiceToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :choice, :string
  end
end
