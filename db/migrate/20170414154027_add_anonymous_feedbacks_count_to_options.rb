class AddAnonymousFeedbacksCountToOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :options, :anonymous_feedbacks_count, :integer, default: 0
  end
end
