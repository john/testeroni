class CreateTakes < ActiveRecord::Migration
  def self.up
    create_table :takes do |t|
      t.integer :tst_id
      t.integer :user_id
      t.integer :questions_answered, :default => 0
      t.integer :questions_correct, :default => 0
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :status, :limit => 1
      t.timestamps
    end
    add_index :takes, :user_id
    add_index :takes, :tst_id
  end

  def self.down
    drop_table :takes
  end
end
