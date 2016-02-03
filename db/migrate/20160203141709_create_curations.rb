class CreateCurations < ActiveRecord::Migration
  def change
    create_table :curations do |t|
      t.text :description
      t.boolean :required
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
