class RequestTasksController < ApplicationController
	before_action :set_request_task, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user

	respond_to :html, :json

	def index
		filter = { }
		date_filter = []
		indicators_filter = []
		@ng_controller = "RequestTasks"
		@request_id  = params[:request_id]
		@who_am_i = params[:who_am_i]
		@overdued = params[:overdued]
		@indicators = params[:indicators]
		if !@who_am_i
			@who_am_i = []
		end

		if !@overdued
			@overdued = []
		end

		if !@indicators
			@indicators = []
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

			@overdued.each do |type|
				case type
				when "done"
				  date_filter << "execution_date IS NOT NULL AND deadline_date < '#{DateTime.now}'"
				when "not_done"
				  date_filter << "execution_date IS NULL AND deadline_date < '#{DateTime.now}'"
				end
			end

			@indicators.each do |type|
				case type
				when "assign"
				  indicators_filter << assign_filter
				when "execute"
				  indicators_filter << execute_filter
				when "audit"
				  indicators_filter << audit_filter
				end
			end
		end
	
		respond_to do |format|
	      format.html { }
	      format.json { render json: RequestTask.joins(:request_message).order("created_at DESC").where(filter).where(date_filter.join(' OR ')).where(indicators_filter.join(' OR ')).collect { |rt| rt.attrs } }
	    end
	end

	def show
		respond_with @request_task.getFullInfo
	end

	def update
		respond_to do |format|
	      if @request_task.update(request_task_params)
	        format.html { redirect_to @request_task, notice: 'Request_task was successfully updated.' }
	        format.json { render json: @request_task.attrs, status: :created }
	      else
	        format.html { render action: 'edit' }
	        format.json { render json: @request_task.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def assign_filter
		"executor_id IS NULL OR deadline_date IS NULL"
	end

	def execute_filter
		"execution_date IS NULL"
	end

	def audit_filter
		"execution_date IS NULL AND deadline_date < '#{DateTime.now}' OR execution_date IS NOT NULL AND audition_date IS NULL"
	end

	def to_assign_count
		filter = {}
		if current_user.employee
			filter[("assigner_id").to_sym] = current_user.employee.id
		end
		respond_with RequestTask.where(filter).where(assign_filter).size
	end

	def to_execute_count
		filter = {}
		if current_user.employee
			filter[("executor_id").to_sym] = current_user.employee.id
		end
		respond_with RequestTask.where(filter).where(execute_filter).size
	end

	def to_audit_count
		filter = {}
		if current_user.employee
			filter[("auditor_id").to_sym] = current_user.employee.id
		end
		respond_with RequestTask.where(filter).where(audit_filter).size
	end

	def signed_in_user
      redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
    end

	private

		def set_request_task
			@request_task = RequestTask.find(params[:id])
		end

		def request_task_params
			params.require(:request_task).permit(:executor_id, 
												 :auditor_id, 
												 :description,
												 :registrar_description,
												 :assigner_description,
												 :executor_description,
												 :auditor_description,
												 :execution_date, 
												 :audition_date, 
												 :deadline_date)
		end
end
