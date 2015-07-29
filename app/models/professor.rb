class Professor < ActiveRecord::Base
  belongs_to :department

  has_many :section_professors, dependent: :destroy
  has_many :reviews, :dependent => :destroy

  has_many :sections, :through => :section_professors
  has_many :courses, :through => :sections
  has_many :subdepartments, :through => :courses

  validates_presence_of :first_name, :last_name

  def courses_list
    return self.courses.uniq{ |p| p.id }#.sort_by{|p| p.subdepartment.mnemonic}
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def separated_name
    if self.last_name == "Staff"
      return "Staff"
    else
      return self.last_name + ", " + self.first_name
    end
  end

  def courses_in_departments(subdepartment)
    courses.where(:subdepartment_id => subdepartment.departments.flat_map(&:subdepartments).uniq.map(&:id))
  end

  def courses_in_subdepartment(subdepartment)
    courses.where(:subdepartment_id => subdepartment.id)
  end

  def most_taught_subdepartment
    counts = Hash.new(0)

    courses.each do |course|
      counts[course.subdepartment.id.to_s.to_sym] += 1
    end

    subdepartment_id = counts.max_by do |id, count|
      count
    end

    if subdepartment_id
      Subdepartment.find(subdepartment_id.first)
    else
      return nil
    end
  end

  def self.consolidate(professors)
    # Arbitrarily choose first professor to assign all sections to
    root = professors[0]
    # For all other duplicate professors
    for professor in professors[1..-1]
      # For each section_professor in each duplicate professor
      professor.section_professors.each do |section_professor|
        # Assign each section_professor with the root professor's id
        SectionProfessor.create({
          :professor_id => root.id,
          :section_id => section_professor.section_id
        })
      end
      # For each review in each duplicate professor
      professor.reviews.each do |review|
        # Assign each review with the root professor's id
        review.update(:professor_id => root.id)
      end
      # After we clear out section_professors for this professor, we delete it
      professor.destroy
    end
  end

  def self.find_by_name(name)
    find_by(:first_name => name.split(' ')[0], :last_name => name.split(' ')[1])
  end

  def self.where_name(name)
    where(:first_name => name.split(' ')[0], :last_name => name.split(' ')[1])
  end

end
