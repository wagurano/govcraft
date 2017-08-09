class AddSequencesToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :discussion_sequence, :integer, default: 0
    add_column :projects, :petition_sequence, :integer, default: 0
    add_column :projects, :poll_sequence, :integer, default: 0
    add_column :projects, :wiki_sequence, :integer, default: 0
    add_column :projects, :event_sequence, :integer, default: 0
  end
end
