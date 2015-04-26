class CreateMajorRequirements < ActiveRecord::Migration
  def change
    create_table :major_requirements do |t|
      t.integer :major_id
      t.integer :credits_required
      t.string :category

      t.timestamps
    end
  end
end
