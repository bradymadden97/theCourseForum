class CreateCoursesMajorRequirementsTable < ActiveRecord::Migration
  def change
    create_table :courses_major_requirements_tables do |t|
    	t.integer :course_id
    	t.integer :major_requirement_id
    end
  end
end
