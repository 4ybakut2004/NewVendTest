class Employee < ActiveRecord::Base
    require 'net/http'

	before_save { self.email = email ? email.downcase : "" }
	
	has_many :users

	validates :name, presence: true, uniqueness: true
	VALID_EMAIL_REGEX = /\A([\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+)?\z/i
  	validates :email, format: { with: VALID_EMAIL_REGEX }

	def attrs
		self.attributes.merge!({ "checked" => false })
	end

	def send_execute_email(params)
		if self.has_email
        	NewVendMailer.execute_email(self, params).deliver
    	end
    end
    handle_asynchronously :send_execute_email

    def send_assign_email(params)
    	if self.has_email
        	NewVendMailer.assign_email(self, params).deliver
    	end
    end
    handle_asynchronously :send_assign_email

    def send_audit_email(params)
    	if self.has_email
        	NewVendMailer.audit_email(self, params).deliver
    	end
    end
    handle_asynchronously :send_audit_email

    def send_assign_sms(params)
        if self.has_phone
            self.send_sms(self, params, "assign")
        end
    end
    handle_asynchronously :send_assign_sms

    def send_execute_sms(params)
        if self.has_phone
            self.send_sms(self, params, "execute")
        end
    end
    handle_asynchronously :send_execute_sms

    def send_audit_sms(params)
        if self.has_phone
            self.send_sms(self, params, "audit")
        end
    end
    handle_asynchronously :send_audit_sms

    def send_sms(employee, params, type)
        url_path = NewVendSettings.first.phone_host_name || '127.0.0.1:3000'
        url_path += '/send_msg?'
        if params[:request]
            url_path += "id=#{params[:request].id}"
        end

        if params[:request_task]
            url_path += "id=#{params[:request_task].id}"
        end

        msg = Employee.create_sms_message(params)

        url_path += "&employee_id=#{employee.id}"
        url_path += "&phone=#{employee.phone}"
        url_path += "&msg=#{msg}"
        url_path += "&type=#{type}"

        url = URI.parse(URI.encode(url_path.strip))
        response = Net::HTTP.get_response(url)
    end

    def has_email
        self.email != nil && self.email != ''
    end

    def has_phone
        self.phone != nil && self.phone != ''
    end

    def self.create_sms_message(params)
        msg = ""
        if params[:request]
            request = params[:request]
            machine_name = request.machine.name

            msg += "Автомат: #{machine_name}\n"

            if request.description && request.description != ""
                msg += "Описание: #{request.description}\n"
            end
        else
            request_task = params[:request_task]
            machine_name = request_task.request_message.request.machine.name
            msg += "Автомат: #{machine_name}\n"

            if request_task.description
                msg += "Описание: #{request_task.description}\n"
            end

            if request_task.registrar_description
                msg += "Регистратор: #{request_task.registrar_description}\n"
            end

            if request_task.assigner_description
                msg += "Назначатель: #{request_task.assigner_description}\n"
            end

            if request_task.executor_description
                msg += "Исполнитель: #{request_task.executor_description}\n"
            end

            if request_task.auditor_description
                msg += "Контролер: #{request_task.auditor_description}\n"
            end
        end

        return msg
    end
end

class Registrar < Employee
	has_many :requests 
end

class Assigner < Employee
	has_many :request_tasks
end

class Executor < Employee
	has_many :request_tasks
end

class Auditor < Employee
	has_many :request_tasks
end