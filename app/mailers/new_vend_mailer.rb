class NewVendMailer < ActionMailer::Base
  default from: 'NewVendSystem@gmail.com'
 
  def send_execute_or_audit_email(employee, params)
    @employee = employee
    @host = getHostName

    @request_task = params[:request_task]
    @request_task_attrs = @request_task.getFullInfo
    @request = @request_task.request_message.request

    @execution_date = @request_task.execution_date ? @request_task.execution_date.utc.localtime.to_s(:ru_datetime) : ''
    @deadline_date = @request_task.deadline_date ? @request_task.deadline_date.utc.localtime.to_s(:ru_datetime) : ''
    @creation_date = @request_task.creation_date ? @request_task.creation_date.utc.localtime.to_s(:ru_datetime) : ''

    subject = "Автомат #{@request_task_attrs["machine_name"]}, #{@action_type}"

    mail(to: @employee.email, subject: subject)
  end

  def execute_email(employee, params)
  	@to_execute_count = RequestTask.to_execute_count(employee)
    @action_type = 'К исполнению'
    send_execute_or_audit_email(employee, params)
  end

  def assign_email(employee, params)
    @to_assign_count = RequestTask.to_assign_count(employee)
    @employee = employee
    @host = getHostName
    @request = params[:request]
    @request_attrs = @request.getFullInfo
    @request_tasks = @request.request_tasks.map { |rt| rt.getFullInfo  }
    @creation_date = @request.created_at ? @request.created_at.utc.localtime.to_s(:ru_datetime) : ''
    subject = "Автомат #{@request.machine.name}, К назначению"

    mail(to: @employee.email, subject: subject)
  end

  def audit_email(employee, params)
    @to_audit_count = RequestTask.to_audit_count(employee)
    @action_type = 'На контроль'
    send_execute_or_audit_email(employee, params)
  end

  def getHostName
    settings = NewVendSettings.first
    if settings.host_name
      return settings.host_name
    else
      return "127.0.0.1:3000"
    end
  end
end
