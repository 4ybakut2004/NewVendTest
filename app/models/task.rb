class Task < ActiveRecord::Base
	has_many :message_tasks, dependent: :destroy
  	has_many :messages, through: :message_tasks
	has_many :request_tasks, dependent: :destroy

	validates :name, presence: true
	validates :deadline, presence: true, numericality: { :greater_than_or_equal_to => 0 }

	def attrs
		self.attributes.merge({ :messages => self.messages.collect { |m| m.name } })
	end
end
