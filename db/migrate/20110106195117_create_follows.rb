class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows do |t|
      t.integer :user_id
      t.integer :follow_type
      t.integer :follow_id
      t.timestamps
    end
    add_index :follows, :user_id
    add_index :follows, :follow_type
    add_index :follows, :follow_id
  end

  def self.down
    drop_table :follows
  end
end
