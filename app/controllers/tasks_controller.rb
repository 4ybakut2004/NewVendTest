class TasksController < ApplicationController
	before_action :set_task, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user

	def index
		@tasks = Task.order("created_at DESC").all
		@task  = Task.new
	end

	def create
		@task = Task.new(task_params)
		messages = params[:messages]
		if !messages
			messages = []
		end

		respond_to do |format|
			if @task.save
				messages.each do |m|
					message_task = MessageTask.create(:message_id => m,
						:task_id => @task.id)
				end

				format.html { redirect_to @task, notice: 'Task was successfully created.' }
				format.js   {}
			else
				format.html { render action: 'new' }
				format.js   {}
			end
		end
	end

	def destroy
		@tasks = Task.all
    
	    @task.destroy
	    respond_to do |format|
	      format.html { redirect_to tasks_url }
	      format.js   {}
	      format.json { head :no_content }
    	end
	end

	def signed_in_user
      redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
    end

	private

		def set_task
			@task = Task.find(params[:id])
		end

		def task_params
			params.require(:task).permit(:name)
		end

		def messages_params
			params.permit(:messages)
		end
end
