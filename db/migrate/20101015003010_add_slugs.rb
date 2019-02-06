class AddSlugs < ActiveRecord::Migration[6.0]
  def change
    add_column :tsts, :slug, :string
    add_index :tsts, :slug, unique: true

    add_column :questions, :slug, :string
    add_index :questions, :slug, unique: true

    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
  end
end
