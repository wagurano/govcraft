class CreateNposAddtionalArchiveDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :npos_addtional_archive_documents do |t|
      t.string :address
      t.string :npo_type
      t.string :zipcode
      t.string :homepage
      t.string :tel
      t.string :leader
      t.string :leader_tel
      t.string :email
      t.string :business_area
      t.string :open_year
      t.integer :members_count
      t.integer :workers_count
      t.integer :finance
      t.timestamps null: false
    end
  end
end
