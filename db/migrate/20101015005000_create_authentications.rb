class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.string :provider
      t.integer :user_id
      t.string :uid
      
      t.string :token # added by jmcgrath
      
      t.timestamps
    end
    add_index :authentications, :user_id
  end

  def self.down
    drop_table :authentications
  end
end
