class CreateTakings < ActiveRecord::Migration
  def self.up
    create_table :takings do |t|
      t.integer :test_id
      t.integer :user_id
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
    add_index :takings, :user_id
    add_index :takings, :test_id
  end

  def self.down
    drop_table :takings
  end
end
