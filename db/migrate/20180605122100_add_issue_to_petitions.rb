class AddIssueToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :petitions, :issue, index: true
  end
end
