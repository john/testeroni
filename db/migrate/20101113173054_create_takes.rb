class CreateTakes < ActiveRecord::Migration
  def self.up
    create_table :takes do |t|
      t.integer :test_id
      t.integer :user_id
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
    add_index :takes, :user_id
    add_index :takes, :test_id
  end

  def self.down
    drop_table :takes
  end
end
