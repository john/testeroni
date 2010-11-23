class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :user_id
      t.integer :test_id
      t.integer :question_id
      t.integer :choice_id
      t.integer :take_id
      t.boolean :answer
      t.boolean :correct
      t.string :name
      t.string :description
      t.timestamps
    end
    add_index :responses, :user_id
    add_index :responses, :test_id
    add_index :responses, :question_id
    add_index :responses, :choice_id
  end

  def self.down
    drop_table :results
  end
end
