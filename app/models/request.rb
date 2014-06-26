class Request < ActiveRecord::Base
    include ActiveModel::Dirty

    belongs_to :machine
    belongs_to :registrar, :class_name => "Employee", :foreign_key => "registrar_id"
    belongs_to :request_type
    has_many :request_messages, dependent: :destroy
    has_many :messages, through: :request_messages
    has_many :request_tasks, through: :request_messages

    validates :machine_id, presence: true
    validates :registrar_id, presence: true
    validates :description, length: { maximum: 512 }
    validate :validate_machine_id

    def getFullInfo
        fullInfo = self.attrs

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
        request_type = self.request_type

        fullInfo = self.attributes
        fullInfo["registrar_name"] = self.registrar.name
        fullInfo["machine_name"] = self.machine.name
        fullInfo["request_type_name"] = request_type ? request_type.name : 'Не задан'

        return fullInfo
    end

    def self.filter(params)
        filter = {}
        who_am_i = params[:who_am_i]
        if !who_am_i
          who_am_i = []
        end

        if params[:signed_in]
          if params[:current_employee]
            who_am_i.each do |i|
              filter[(i + "_id").to_sym] = params[:current_employee].id
            end
          end
        end

        Request.order('id DESC').where(filter)
    end

    private

        def validate_machine_id
            errors.add(:machine_id, "is invalid") unless Machine.exists?(self.machine_id)
        end
end
