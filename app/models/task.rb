class Task < ActiveRecord::Base
	has_many :message_tasks, dependent: :destroy
	has_many :messages, through: :message_tasks
	has_many :request_tasks, dependent: :destroy

	belongs_to :solver, :class_name => "Solver", :foreign_key => "solver_id"

	validates :name, presence: true, uniqueness: true
	validates :deadline, presence: true, numericality: { :greater_than_or_equal_to => 0 }

	def attrs
		solver = self.solver
		self.attributes.merge({ :messages => self.messages.collect { |m| m.name },
								:solver_name => solver ? solver.name : nil })
	end
end
