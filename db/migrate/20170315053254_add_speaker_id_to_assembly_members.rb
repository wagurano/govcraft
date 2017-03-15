class AddSpeakerIdToAssemblyMembers < ActiveRecord::Migration[5.0]
  def change
    add_reference :assembly_members, :speaker
  end
end
