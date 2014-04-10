class Request < ActiveRecord::Base
    include ActiveModel::Dirty

	belongs_to :machine
	belongs_to :registrar, :class_name => "Employee", :foreign_key => "registrar_id"
	has_many :request_messages, dependent: :destroy
  	has_many :messages, through: :request_messages
  	has_many :request_tasks, through: :request_messages

	validates :machine_id, presence: true
	validates :registrar_id, presence: true
	validate :validate_machine_id
	validates_inclusion_of :request_type, :in => [:phone, :other]

	REQUEST_TYPES = {
	    :phone => "С Телефона",
	    :other => "Произвольная"
	}

	def request_type
    	read_attribute(:request_type).to_sym
    end

    def request_type= (value)
    	write_attribute(:request_type, value.to_s)
    end

    def self.request_types
    	REQUEST_TYPES
    end

    def getFullInfo
    	fullInfo = self.attributes
        fullInfo["registrar_name"] = self.registrar.name
        fullInfo["machine_name"] = self.machine.name
        fullInfo["request_type_name"] = Request.request_types[self.request_type]
    	fullInfo["request_messages"] = self.request_messages.map { |m| m.message.name }
    	fullInfo["request_tasks"] = self.request_tasks.map { |t| t.task.name }
    	return fullInfo
    end

	private

	  def validate_machine_id
	    errors.add(:machine_id, "is invalid") unless Machine.exists?(self.machine_id)
	  end
end
