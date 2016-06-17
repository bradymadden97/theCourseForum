class Major < ActiveRecord::Base
  has_many :student_majors
  has_many :students, :through => :student_majors
  has_many :major_requirements

  validates_presence_of :name

  def full_name
    "#{name}"
  end
end
