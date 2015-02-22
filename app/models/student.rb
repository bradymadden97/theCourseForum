class Student < ActiveRecord::Base
  belongs_to :user

  has_and_belongs_to_many :majors

  validates :grad_year, presence: true
end
