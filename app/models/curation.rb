class Curation < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
  belongs_to :major


  validates_presence_of :student_id, :course_id, :major_id

  validates_uniqueness_of :student_id, :scope => [:course_id, :major_id]

  def self.find_by_major(major)
    Curation.select do |curation|           
        
    end
  end


end
