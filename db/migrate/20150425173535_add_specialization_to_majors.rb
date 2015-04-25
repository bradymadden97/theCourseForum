class AddSpecializationToMajors < ActiveRecord::Migration
  def change
    add_column :majors, :specialization, :string
  end
end
