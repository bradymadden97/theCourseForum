class CurationsController < ApplicationController

  before_action :is_correct_user, :only => [:create]

  # GET /curations
  def index
    @majors = Major.all
  end

  def show
    @major = Major.find(params[:id])
    @curations = Curation.where(major_id: @major.id)
  end

  # GET /curations/new
  def new
    @curation = current_user.student.curations.build()
    @subdepartments = Subdepartment.all.order(:name)
    @curation = Curation.new
    @majors = Major.all.order(:name)
    p "Course_id is"
    @course_id = params[:c]
    puts @course_id

    puts @course_id
    # if @course_id
      @subdepartment = Subdepartment.find(Course.find(@course_id).subdepartment_id)
      @subdept_id = @subdepartment.id
      @courses = Course.where(:subdepartment_id => @subdept_id)
      @mnemonic = @subdepartment.mnemonic
    # end
  end

  # POST /curations
  # POST /curations.json
  def create
    c = Curation.find_by(:student_id => current_user.id, :course_id => params[:course_select], :major_id => params[:major_select])
    if r != nil
      flash[:notice] = "You have already written a curation on this class for this major."
      redirect_to curations_path
      return
    end
    @curation = current_user.student.curations.build(curation_params)
    @curation = Curation.new(curation_params)

    @curation.major_id = params[:major_select]
    @curation.course_id = params[:course_select]
    @curation.student_id = current_user.id

    # if @curation.save
    #   redirect_to curations_path, notice: 'Curation was successfully created.'
    # else
    #   render action[:new]
    # end

    respond_to do |format|
      if @curation.save      
        format.html { redirect_to curations_path, notice: 'Curation was successfully created.' }
        format.json { render json: @curation, status: :created, location: @curation }
      else
        format.html { render action: "new" }
        format.json { render json: @curation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def curation_params
      params.require(:curation).permit(:description, :require)
    end

    def is_correct_user
      @curation = Curation.find(params[:id])
      if current_user.id != @curation.student_id
        redirect_to curations_path
      end
    end
  

end
