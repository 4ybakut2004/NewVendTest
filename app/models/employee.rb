class Employee < ActiveRecord::Base
	before_save { self.email = email ? email.downcase : "" }
	
	has_many :users
	has_many :messages

	validates :name, presence: true
	VALID_EMAIL_REGEX = /\A([\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+)?\z/i
  	validates :email, format: { with: VALID_EMAIL_REGEX }

	def attrs
		self.attributes.merge!({ "checked" => false })
	end
end

class Solver < Employee
	has_many :tasks 
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