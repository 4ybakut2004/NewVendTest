class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  include SessionsHelper

  WRONG_PARAMS_RESPONSE = "Неверные параметры"
  NO_EMPLOYEE_RESPONSE  = "Сотрудника с таким номером телефона не существует"
  READ_RESPONSE         = "Прочитано!"

  respond_to :html, :json

  def mobile
    phone    = ApplicationController.parse_phone(params[:phone])
    sms_code = params[:msg].to_i

    if phone == nil
      respond_with WRONG_PARAMS_RESPONSE
      return
    end

    employee = Employee.where(phone: phone).first
    if employee == nil
      respond_with NO_EMPLOYEE_RESPONSE
      return
    end

    # Получаем непрочитанные сообщения с переданным кодом
    requestTasks = requestTasksToRead(employee: employee, sms_code: sms_code)

    requestTasks.each { |rt|
      if rt.validate_read_by_auditor(employee)
        rt.update({is_read_by_auditor: true})
        if sms_code == Employee.first_code
          employee.free_first_code
        end
      end

      if rt.validate_read_by_executor(employee)
        rt.update({is_read_by_executor: true})
        if sms_code == Employee.first_code
          employee.free_first_code
        end
      end

      # Если в непрочитанном сообщении сотрудник является назначателем,
      # то нужно прочитать все поручения заявки
      if rt.validate_read_by_assigner(employee)
        rt.request_message.request.request_tasks.each { |requestTask|
          if requestTask.validate_read_by_assigner(employee)
            requestTask.update({is_read_by_assigner: true})
            if requestTask.assigner_sms_code == Employee.first_code
              employee.free_first_code
            end
          end
        }
      end
    }

    respond_with READ_RESPONSE
  end

  def requestTasksToRead(parameters)
    sms_code = parameters[:sms_code]
    employee = parameters[:employee]
    assigner_request = "assigner_id = :employee_id AND is_read_by_assigner = FALSE AND email_to_assigner_date IS NOT NULL"
    executor_request = "executor_id = :employee_id AND is_read_by_executor = FALSE AND email_to_executor_date IS NOT NULL"
    auditor_request  = "auditor_id  = :employee_id AND is_read_by_auditor  = FALSE AND email_to_auditor_date  IS NOT NULL"

    if sms_code
     assigner_request += " AND assigner_sms_code = :sms_code"
     executor_request += " AND executor_sms_code = :sms_code"
     auditor_request  += " AND auditor_sms_code  = :sms_code"
    end

    request = assigner_request + " OR " + executor_request + " OR " + auditor_request
    RequestTask.order("id DESC").where(request, {employee_id: employee.id, sms_code: sms_code})
  end

  def self.parse_phone(phone)
    phone.gsub(/\+7/, "8")
  end

end
