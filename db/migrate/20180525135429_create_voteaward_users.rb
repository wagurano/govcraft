class CreateVoteawardUsers < ActiveRecord::Migration[5.0]
  def self.up
    create_table :voteaward_users do |t|
      t.string :name
      t.string :password
      t.string :email
      t.string :oid, :null => false
      t.string :omniauth
      t.string :omniauth_token
      t.string :omniauth_expires_at
      t.boolean :omniauth_expires
      t.string :omniauth_image
      t.string :omniauth_provider, :null => false
      t.string :omniauth_uid, :null => false
      t.string :omniauth_url

      t.integer :user_id

      t.timestamps
    end

    add_index :voteaward_users, [:omniauth_provider, :omniauth_uid], name: 'idx_voteaward_users_uid'
    add_index :voteaward_users, [:oid], name: 'idx_voteaward_users_oid'
  end

  def self.down
    drop_table :voteaward_users
  end
end
