class Curation < ActiveRecord::Base
  belongs_to :student

  def self.find_by_major(major)
  	Curation.select do |curation|   		
  		(StudentMajor.find_by student_id: curation.student_id).major == major
  	 end
  end


end
