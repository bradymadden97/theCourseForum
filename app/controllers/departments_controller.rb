class DepartmentsController < ApplicationController
  # GET /departments
  # GET /departments.json
  def index
    if current_user == nil
      redirect_to root_url
      return
    end
    subdepartments = Subdepartment.all
    departments = Department.all.order(:name)
    departments.uniq {|subdepartments| subdepartments.name}
    schools = School.all.order(:name)
    artSchoolId = 1
    engrSchoolId = 2

    @artDeps = columnize(departments.select{|d| d.school_id == artSchoolId})
    @engrDeps = columnize(departments.select{|d| d.school_id == engrSchoolId })
    @otherSchools = columnize(departments.select{|d| d.school_id != artSchoolId && d.school_id != engrSchoolId })
    @comments = self.grab_reviews


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @departments }
    end

  end


  # GET /departments/1
  def show
    @department = Department.includes(:subdepartments => [:courses => [:overall_stats, :last_taught_semester]]).find(params[:id])

    add_breadcrumb 'Departments', departments_url
    add_breadcrumb @department.name
    
    @subdepartments = @department.subdepartments.sort_by(&:mnemonic)

    @groups = @subdepartments.map do |subdepartment|
      subdepartment.courses.sort_by(&:course_number).chunk do |course|
        course.course_number / 1000
      end.map(&:last)
    end

    @current_semester = Semester.current

    @current_courses = @department.courses.where(:last_taught_semester => @current_semester)

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def grab_reviews
    top_20_comments = {}
    vote_array = Vote.all.pluck(:"voteable_id")
    freq = vote_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

    (0...20).each do
      top_vote = vote_array.max_by { |v| freq[v]}
      top_review = Review.find_by(id: top_vote)

      top_comment = top_review["comment"]
      top_course = Course.find(top_review["course_id"])
      title = top_course["title"]

      top_20_comments[title] = top_comment

      freq.delete(top_vote)
    end

    return top_20_comments
  end


  private
    def department_params
      params.require(:department).permit(:name)
    end

end
