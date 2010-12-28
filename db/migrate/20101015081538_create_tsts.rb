class CreateTsts < ActiveRecord::Migration
  def self.up
    create_table :tsts do |t|
      t.integer :user_id
      t.string :username
      t.string :name
      t.string :description
      t.integer :status, :limit => 1
      t.integer :contributors, :limit => 1
      t.datetime :published_at
      t.timestamps
    end
    add_index :tsts, :user_id
    add_index :tsts, :name
  end

  def self.down
    drop_table :tsts
  end
end
