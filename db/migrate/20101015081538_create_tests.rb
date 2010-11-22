class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.datetime :published_at
      t.timestamps
    end
    add_index :tests, :user_id
    add_index :tests, :name
  end

  def self.down
    drop_table :tests
  end
end
