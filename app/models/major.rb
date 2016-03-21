class Major < ActiveRecord::Base
  has_many :students, :through => :student_majors
  has_many :curations
  
  validates_presence_of :name
end
