class MajorsController < ApplicationController

	def index
		@majors = Major.all
	end
	
end