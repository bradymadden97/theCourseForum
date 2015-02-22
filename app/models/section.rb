class Section < ActiveRecord::Base
  belongs_to :course
  belongs_to :semester

  has_many :grades

  has_and_belongs_to_many :day_times
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :professors
  has_and_belongs_to_many :users

  def conflicts?(other_section)
    day_times.each do |day_time|
      other_section.day_times.each do |other_day_time|
        if day_time.overlaps?(other_day_time)
          return true
        end
      end
    end
    return false
  end

end
