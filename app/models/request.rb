class Request < ActiveRecord::Base
    include ActiveModel::Dirty

	belongs_to :machine
	belongs_to :registrar, :class_name => "Employee", :foreign_key => "registrar_id"
    belongs_to :request_type
    belongs_to :request_task
	has_many :request_messages, dependent: :destroy
  	has_many :messages, through: :request_messages
  	has_many :request_tasks, through: :request_messages

	validates :machine_id, presence: true
	validates :registrar_id, presence: true
	validate :validate_machine_id

	REQUEST_TYPES = {
	    :phone => "С Телефона",
	    :other => "Произвольная"
	}

    def self.request_types
    	REQUEST_TYPES
    end

    def getFullInfo
    	fullInfo = self.attributes
        fullInfo["registrar_name"] = self.registrar.name
        fullInfo["machine_name"] = self.machine.name
        fullInfo["request_type_name"] = self.request_type ? self.request_type.name : 'Не задан'
        fullInfo["request_messages"] = self.request_messages.map { |rm|
            {"request_tasks" => rm.request_tasks.map { |rt| rt.task.name },
             "request_attributes" => rm.request_attributes.map { |ra| { 
                "id" => ra.id, 
                "name" => ra.attribute.name, 
                "value" => ra.value } 
             },
             "name" => rm.message.name}
        }
    	return fullInfo
    end

    def attrs
        self.attributes.merge({
            "registrar_name" => self.registrar.name,
            "machine_name" => self.machine.name,
            "request_type_name" => self.request_type ? self.request_type.name : 'Не задан'
        })
    end

	private

	  def validate_machine_id
	    errors.add(:machine_id, "is invalid") unless Machine.exists?(self.machine_id)
	  end
end
