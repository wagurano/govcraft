class RemoveUniqIndexOfSigns < ActiveRecord::Migration[5.0]
  def up
    remove_index :signs, ["petition_id", "signer_email"]
  end

  def down
    add_index :signs, ["petition_id", "signer_email"], unique: true
  end
end
