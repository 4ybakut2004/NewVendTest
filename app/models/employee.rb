class Employee < ActiveRecord::Base
	has_many :users
	has_many :messages

	validates :name, presence: true

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