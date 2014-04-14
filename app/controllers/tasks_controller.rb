class TasksController < ApplicationController
	before_action :set_task, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user

	respond_to :html, :json

	def index
		@ng_controller = "Tasks"

    	respond_to do |format|
	      format.html { }
	      format.json { render json: @tasks = Task.order("created_at DESC").all.collect { |t| t.attrs } }
	    end
	end

	def create
		@task = Task.new(task_params)
		messages = params[:messages]
		if !messages
			messages = []
		end

		if @task.save
			messages.each do |m|
				message_task = MessageTask.create(:message_id => m,
					:task_id => @task.id)
			end

			respond_with(@task.attrs, :status => :created, :location => @task)
		else
			respond_with(@task.errors, :status => :unprocessable_entity)
		end
	end

	def update
		respond_to do |format|
		  if @task.update(task_params)
		    format.html { redirect_to @task, notice: 'Task was successfully updated.' }
		    format.json { render json: @task.attrs, status: :created }
		  else
		    format.html { render action: 'edit' }
		    format.json { render json: @task.errors, status: :unprocessable_entity }
		  end
		end
	end

	def destroy
		@task.destroy
	    respond_to do |format|
	      format.html { redirect_to tasks_url }
	      format.json { render json: @task.attrs }
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
			params.require(:task).permit(:name, :deadline)
		end
end
