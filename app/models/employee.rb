class Employee < ActiveRecord::Base
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

    def has_email
        self.email != nil && self.email != ''
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