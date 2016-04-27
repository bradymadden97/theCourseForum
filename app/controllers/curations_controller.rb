class CurationsController < ApplicationController

	def index
		@majors = Major.all
	end

	def show
		@major = Major.find(params[:id])
		@curations = Curation.where(major_id: @major.id)
	end

	def new
		@curation = current_user.student.curations.build()
		@subdepartments = Subdepartment.all.order(:name)
		@curation = Curation.new
		@majors = Major.all.order(:name)	
	end

	def create
		@curation = current_user.student.curations.build(curation_params)
		@curation = Curation.new(curation_params)
		# @curation.course_id = params[:course_select].id;
		@curation.major_id = params[:major_select]
		@curation.student_id = current_user.id
		if @curation.save
			redirect_to curations_path, notice: 'Curation was successfully created.'
		else
			render action[:new]
		end
	end

  private
	def curation_params
		params.require(:curation).permit(:description, :require)
	end
  

end
