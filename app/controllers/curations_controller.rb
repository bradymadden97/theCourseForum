class CurationsController < ApplicationController

	def index
		@majors = Major.all
	end

	def show
		@major = Major.find(params[:id])
		@curations = Curation.find_by_major(@major)
	end

	def new
		@curation = current_user.student.curations.build()		
	end

	def create
		@curation = current_user.student.curations.build(curation_params)		
		if @curation.save
	      flash[:success] = "Class saved!"	      
	    # else
	    	#TODO: handle errors
	    end
	end



end
