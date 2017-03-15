class AddJpgLinkToAssemblyMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :assembly_members, :jpgLink, :string
  end
end
