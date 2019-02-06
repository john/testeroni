class CreateActivities < ActiveRecord::Migration[6.0]
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.integer :verb
      t.integer :object_type
      t.integer :object_id
      t.timestamps
    end
    add_index :activities, :user_id
    add_index :activities, :object_type
    add_index :activities, :object_id
  end

  def self.down
    drop_table :activities
  end
end
