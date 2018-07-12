class SignFormIntroToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :sign_form_intro, :string
  end
end
