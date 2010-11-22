class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :username
      t.boolean :email_list
      t.database_authenticatable :null => false # creates encrypted_password and password_salt fields
      t.recoverable # creates reset_password_token field
      t.rememberable # creates remember_token and remember_created_at
      t.trackable # creates sign_in fields

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end
