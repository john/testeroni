class AddPositionToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :position, :int
  end
end
