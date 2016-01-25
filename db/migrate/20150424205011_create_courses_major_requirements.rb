class CreateCoursesMajorRequirements < ActiveRecord::Migration
  def change
    create_table :courses_major_requirements do |t|
    	t.integer :course_id
    	t.integer :major_requirement_id
    end
  end
end
