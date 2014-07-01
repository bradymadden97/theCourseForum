class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text,               null: false
      t.integer :review_id
      t.integer :comment_id

      t.timestamps
    end
  end
end
