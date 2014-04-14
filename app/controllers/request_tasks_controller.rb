class RequestTasksController < ApplicationController
	before_action :set_request_task, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user

	def edit
	end

	def index
		filter = { }
		@request_id  = params[:request_id]
		@who_am_i = params[:who_am_i]
		if !@who_am_i
			@who_am_i = []
		end
		
		if @request_id != "" && @request_id
			filter[:request_messages] = { :request_id => @request_id }
		end

		if signed_in?
			if current_user.employee
				@who_am_i.each do |i|
					filter[(i + "_id").to_sym] = current_user.employee.id
				end
			end
		end

		@request_tasks = RequestTask.joins(:request_message).order("created_at DESC").where(filter)
		
		respond_to do |format|
	        format.html { }
	        format.js   {}
	        format.json { render json: @request_tasks, status: :created}
	    end
	end

	def update
		respond_to do |format|
	      if @request_task.update(request_task_params)
	        format.html { redirect_to @request_task, notice: 'Request_task was successfully updated.' }
	        format.js   {}
	        format.json { render json: @request_task, status: :created, location: @request_task }
	      else
	        format.html { render action: 'edit' }
	        format.js   {}
	        format.json { render json: @request_task.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def signed_in_user
      redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
    end

	private

		def set_request_task
			@request_task = RequestTask.find(params[:id])
		end

		def request_task_params
			params.require(:request_task).permit(:executor_id, :auditor_id, :description, :execution_date, :audition_date, :deadline_date)
		end
end
