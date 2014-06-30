class RequestTasksController < ApplicationController
	before_action :set_request_task, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user, except: [:read]

	respond_to :html, :json

	def index
		@ng_controller = "RequestTasks"

		parm = params.dup
		parm[:signed_in] = signed_in?
		parm[:current_employee] = current_user.employee
		page_num = params[:page] || 1

		# Формируем ответ
		respond_to do |format|
			format.html { }
			format.json { render json: RequestTask.page(page_num, parm).collect { |rt| rt.attrs } }
		end
	end

	def count
		parm = params.dup
		parm[:signed_in] = signed_in?
		parm[:current_employee] = current_user.employee

		respond_with RequestTask.filter(parm).size
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
					@request_task.set_executor_sms_code
					params[:sms_code] = @request_task.executor_sms_code
					@request_task.executor.send_execute_email(params)
					@request_task.executor.send_execute_sms(params)
					
				end

				if audit_email
					@request_task.set_auditor_sms_code
					params[:sms_code] = @request_task.auditor_sms_code
					@request_task.auditor.send_audit_email(params)
					@request_task.auditor.send_audit_sms(params)
				end

				format.json { render json: @request_task.attrs, status: :created }
			else
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

	def to_read_by_assigner_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_read_by_assigner_count(employee)
		end
	end

	def to_read_by_executor_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_read_by_executor_count(employee)
		end
	end

	def to_read_by_auditor_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_read_by_auditor_count(employee)
		end
	end

	def to_read_by_employee_count
		employee = current_user.employee
		if employee
			respond_with RequestTask.to_read_by_employee_count(employee)
		end
	end

	def read
		response = ""
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
		# Чтение целой заявки
			@request = Request.find_by_id(params[:id])
			if @request
				@request.request_tasks.each do |rt|
					if rt.validate_read_by_assigner(employee)
						rt.update({:is_read_by_assigner => true})
						if rt.assigner_sms_code == Employee.first_code
							employee.free_first_code
						end
					end
				end
			else
				@error = true
				response = "can't find request"
			end
		else
		# Чтение отдельного поручения
			@request_task = RequestTask.find_by_id(params[:id])
			if @request_task
				# Выставляем поручению статус прочитано только тогда,
				# когда его читает ответственный за нее человек
				if @request_task.validate_read_by_assigner(employee)
					@request_task.update({:is_read_by_assigner => true})
					if @request_task.assigner_sms_code == Employee.first_code
						employee.free_first_code
					end
				elsif @request_task.validate_read_by_executor(employee)
					@request_task.update({:is_read_by_executor => true})
					if @request_task.executor_sms_code == Employee.first_code
						employee.free_first_code
					end
				elsif @request_task.validate_read_by_auditor(employee)
					@request_task.update({:is_read_by_auditor => true})
					if @request_task.auditor_sms_code == Employee.first_code
						employee.free_first_code
					end
				end

				# Формируем ответ для обновления данных на клиенте
				response = { :is_read_by_executor => @request_task.is_read_by_executor,
					:is_read_by_assigner => @request_task.is_read_by_assigner,
					:is_read_by_auditor => @request_task.is_read_by_auditor }
			else
				@error = true
				response = "can't find request task"
			end
		end

		respond_with response
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
