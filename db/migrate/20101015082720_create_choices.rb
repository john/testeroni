class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.integer :question_id
      t.string :name
      t.string :description
      t.string :explanation
      t.boolean :correct
      t.timestamps
    end
    add_index :choices, :question_id
  end

  def self.down
    drop_table :choices
  end
end
