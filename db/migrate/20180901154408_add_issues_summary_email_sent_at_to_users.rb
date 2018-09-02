class AddIssuesSummaryEmailSentAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :issues_summary_email_sent_at, :datetime
  end
end
