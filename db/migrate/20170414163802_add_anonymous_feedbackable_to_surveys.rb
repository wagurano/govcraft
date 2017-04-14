class AddAnonymousFeedbackableToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :anonymous_feedbackable, :boolean, default: false
  end
end
