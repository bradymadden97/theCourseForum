class Curation < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
  belongs_to :major

  def self.find_by_major(major)
  	Curation.select do |curation|   		
  		
  	end
  end


end
