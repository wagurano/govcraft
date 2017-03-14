class CreateAssemblyMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :assembly_members, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string :deptCd
      t.string :num
      t.string :assemEmail
      t.string :assemHomep
      t.string :assemTel
      t.string :bthDate
      t.string :electionNum
      t.string :empNm
      t.string :engNm
      t.text :examCd
      t.text :hbbyCd
      t.string :hjNm
      t.text :memTitle
      t.string :origNm
      t.string :polyNm
      t.string :reeleGbnNm
      t.text :secretary
      t.text :secretary2
      t.string :shrtNm
      t.string :staff
      t.timestamp null: false
    end
  end
end
