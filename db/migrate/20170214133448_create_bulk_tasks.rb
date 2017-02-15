class CreateBulkTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :bulk_tasks, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC" do |t|
      t.string :job_id, null: true, index: true
      t.text :desc
      t.references :user, null: false, index: true
      t.references :archive, null: false, index: true
      t.string :attachment
      t.string :attachment_name
      t.string :status, default: '등록', null: false
      t.integer :processing_count, default: 0
      t.integer :success_count, default: 0
      t.integer :error_count, default: 0
      t.integer :inserted_count, default: 0
      t.integer :updated_count, default: 0
      t.text :error_detail
      t.timestamps null: false
    end
  end
end
