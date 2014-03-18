class Employee < ActiveRecord::Base
	has_many :users
end

class Registrar < Employee
	has_many :requests 
end

class Solver < Employee
	has_many :requests
end

class Assigner < Employee
	has_many :message_tasks
end

class Executor < Employee
	has_many :message_tasks
end

class Auditor < Employee
	has_many :message_tasks
end