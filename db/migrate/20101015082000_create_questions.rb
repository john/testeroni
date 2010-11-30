class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :test_id
      t.integer :user_id
      t.string :name
      t.string :description
      t.integer :status, :limit => 3
      t.string :image_url
      t.string :explanation
      t.integer :kind            # true/false or multiple choice, holds a constant
      t.integer :correct_response          # 1 = true, 0 = false, 2 = multiple choice
      t.timestamps
    end
    add_index :questions, :test_id
    add_index :questions, :user_id
  end

  def self.down
    drop_table :questions
  end
end
