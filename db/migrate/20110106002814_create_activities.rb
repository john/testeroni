class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.integer :verb
      t.string :object_type
      t.integer :object_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
