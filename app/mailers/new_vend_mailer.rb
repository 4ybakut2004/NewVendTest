class NewVendMailer < ActionMailer::Base
  default from: 'NewVendSystem@gmail.com'
 
  def send_email(employee)
  	@employee = employee
    @url  = 'http://194.126.168.74:8081/request_tasks'
    @sign_in_url = 'http://194.126.168.74:8081/signin'

    if @employee.email
    	mail(to: @employee.email, subject: 'Новый Вендинг')
	end
  end

  def execute_email(employee)
  	@to_execute_count = RequestTask.to_execute_count(employee)
    send_email(employee)
  end

  def assign_email(employee, tasks_count)
  	@to_assign_count = RequestTask.to_assign_count(employee)
  	@tasks_count = tasks_count
  	send_email(employee)
  end

  def audit_email(employee)
  	@to_audit_count = RequestTask.to_audit_count(employee)
    send_email(employee)
  end
end
