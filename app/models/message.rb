class Message < ActiveRecord::Base
	  has_many :request_messages, dependent: :destroy
  	has_many :requests, through: :request_messages
  	has_many :message_tasks, dependent: :destroy
  	has_many :tasks, through: :message_tasks
  	has_many :message_attributes, dependent: :destroy

  	belongs_to :employee

  	validates :name, presence: true
  	validates :request_type, presence: true

  	def attrs
  		self.attributes.merge({ :tasks => self.tasks, 
                              :attributes => self.message_attributes.collect { |a| a.attribute } ,
                              :request_type_name => Request.request_types[self.request_type.to_sym],
                              :solver_name => self.employee ? self.employee.name : nil
                            }) 
  	end
end