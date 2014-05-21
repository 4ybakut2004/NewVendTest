class RequestTasksController < ApplicationController
	before_action :set_request_task, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user, except: [:read]

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
				  indicators_filter << RequestTask.assign_filter
				when "execute"
				  indicators_filter << RequestTask.execute_filter
				when "audit"
				  indicators_filter << RequestTask.audit_filter
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
		  # Перезаписываем атрибуты.
		  # Не испольузем update, так как он автоматически сохраняет запись,
		  # А нам нужно посмотреть, какие поля были изменены
		  @request_task.assign_attributes(request_task_params)

		  # Смотрим, нужно ли отсылась письма после редактирования поручения
		  execute_email = @request_task.needs_send_execute_email
		  audit_email = @request_task.needs_send_audit_email

		  # Если нужно отправить письма, сохраняем даты отправки
		  if execute_email
		  	@request_task.email_to_executor_date = DateTime.now
		  end

		  if audit_email
		  	@request_task.email_to_auditor_date = DateTime.now
		  end

		  # Остальное делаем, если при сохранении записи не было ошибок
	      if @request_task.save
	      	# Эти данные нужны отправщику сообщений для формирования письма
	      	params = {
                :request_task => @request_task,
                :host => request.host_with_port
            }

            # Отсылаем письма, если необходимо
	      	if execute_email
	      		@request_task.executor.send_execute_email(params)
	      	end

	      	if audit_email
	      		@request_task.auditor.send_audit_email(params)
	      	end

	        format.html { redirect_to @request_task, notice: 'Request_task was successfully updated.' }
	        format.json { render json: @request_task.attrs, status: :created }
	      else
	        format.html { render action: 'edit' }
	        format.json { render json: @request_task.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def to_assign_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_assign_count(employee)
		end
	end

	def to_execute_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_execute_count(employee)
		end
	end

	def to_audit_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_audit_count(employee)
		end
	end

	def to_read_assign_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_read_assign_count(employee)
		end
	end

	def to_read_execute_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_read_execute_count(employee)
		end
	end

	def to_read_audit_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_read_audit_count(employee)
		end
	end

	def read
		# Если получили сотрудника в запросе, ищем его в базе данных.
		# Это означает переход по ссылки в email
		if params[:employee_id]
			employee = Employee.find(params[:employee_id])
		# Иначе получаем из текущего пользователя.
		# Это означает работу в системе
		else
			employee = current_user.employee
		end

		if params[:type] == "assign"
		# Этот случай означает, что переход осуществился через письмо,
		# и обработать нужно целую заявку, причем только для назначателей
			@request = Request.find(params[:id])
			@request.request_tasks.each do |rt|
				if rt.validate_read_by_assigner(employee)
					rt.update({:is_read_by_assigner => true})
				end
			end
		else
			@request_task = RequestTask.find(params[:id])
			# Выставляем поручению статус прочитано только тогда,
			# когда его читает ответственный за нее человек
			if @request_task.validate_read_by_assigner(employee)
				@request_task.update({:is_read_by_assigner => true})
			elsif @request_task.validate_read_by_executor(employee)
				@request_task.update({:is_read_by_executor => true})
			elsif @request_task.validate_read_by_auditor(employee)
				@request_task.update({:is_read_by_auditor => true})
			end

			# Формируем ответ для обновления данных на клиенте
			response = { :is_read_by_executor => @request_task.is_read_by_executor,
				:is_read_by_assigner => @request_task.is_read_by_assigner,
				:is_read_by_auditor => @request_task.is_read_by_auditor }

			respond_with response
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
