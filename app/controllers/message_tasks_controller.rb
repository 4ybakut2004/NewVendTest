class MessageTasksController < ApplicationController
	before_action :set_message_task, only: [:show, :edit, :update, :destroy]

	def edit
	end

	def index
		filter = { }
		@request_id  = params[:request_id]
		@action_type = params[:action_type]
		if @request_id != "" && @request_id
			filter[:request_messages] = { :request_id => @request_id }
		end

		if signed_in?
			case @action_type
			when "my"
			  	filter[:assigner_id] = current_user.employee.id
			when "to_me"
			  	filter[:executor_id] = current_user.employee.id
			when "to_audit"
			  	filter[:auditor_id] = current_user.employee.id
			end
		end

		@message_tasks = MessageTask.joins(:request_message).order("created_at DESC").where(filter)
	end

	def update
		respond_to do |format|
	      if @message_task.update(message_task_params)
	        format.html { redirect_to @message_task, notice: 'Message_task was successfully updated.' }
	        format.js   {}
	        format.json { render json: @message_task, status: :created, location: @message_task }
	      else
	        format.html { render action: 'edit' }
	        format.js   {}
	        format.json { render json: @message_task.errors, status: :unprocessable_entity }
	      end
	    end
	end

	private

		def set_message_task
			@message_task = MessageTask.find(params[:id])
		end

		def message_task_params
			params.require(:message_task).permit(:executor_id, :auditor_id, :description, :execution_date, :audition_date)
		end
end
