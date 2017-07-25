class AddCategoryIdToDiscussions < ActiveRecord::Migration[5.0]
  def change
    add_reference :discussions, :discussion_category, index: true
  end
end
