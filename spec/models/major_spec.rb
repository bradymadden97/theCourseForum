require 'rails_helper'

RSpec.describe Major, :type => :model do
  it { should have_many(:students).through(:student_majors)}
  it { should have_many(:major_requirements) }

  it { should validate_presence_of(:name) }
  
  
end