class ActsAsCommentableWithThreadingMigration < ActiveRecord::Migration[6.0]
  def self.up
    create_table :comments, :force => true do |t|
      t.integer :tst_id, :default => 0
      t.integer :question_id, :default => 0
      t.integer :commentable_id, :default => 0
      t.string :commentable_type, :limit => 15, :default => ""
      t.string :title, :default => ""
      t.text :body, :default => ""
      t.string :subject, :default => ""
      t.integer :user_id, :default => 0, :null => false
      t.integer :parent_id, :lft, :rgt
      t.timestamps

      t.string :display_name, :default => ""
    end

    add_index :comments, :user_id
    add_index :comments, :commentable_id
  end

  def self.down
    drop_table :comments
  end
end
