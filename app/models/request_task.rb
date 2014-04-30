class RequestTask < ActiveRecord::Base
	belongs_to :task
	belongs_to :request_message

    has_many :requests

	belongs_to :assigner, :class_name => "Employee", :foreign_key => "assigner_id"
	belongs_to :executor, :class_name => "Employee", :foreign_key => "executor_id"
	belongs_to :auditor, :class_name => "Employee", :foreign_key => "auditor_id"

    before_save :set_audition_entering_date

	def getFullInfo
        request_message = self.request_message
        assigner = self.assigner
        executor = self.executor
        auditor = self.auditor

    	fullInfo = self.attributes
        fullInfo["request_id"] = request_message.request_id
        fullInfo["task_name"] = self.task.name
        fullInfo["assigner_name"] = assigner ? assigner.name : nil
        fullInfo["executor_name"] = executor ? executor.name : nil
        fullInfo["auditor_name"] = auditor ? auditor.name : nil
        fullInfo["checked"] = false;

        fullInfo["request"] = request_message.request.getFullInfo
        fullInfo["attributes"] = request_message.request_attributes.collect { |ra| { :name => ra.attribute.name, :value => ra.value } }

        return fullInfo
    end

    def attrs
        request_message = self.request_message
        assigner = self.assigner
        executor = self.executor
        auditor = self.auditor

    	fullInfo = self.attributes
        fullInfo["request_id"] = request_message.request_id
        fullInfo["machine_name"] = request_message.request.machine.name
    	fullInfo["task_name"] = self.task.name
    	fullInfo["assigner_name"] = assigner ? assigner.name : nil
    	fullInfo["executor_name"] = executor ? executor.name : nil
    	fullInfo["auditor_name"] = auditor ? auditor.name : nil
        fullInfo["checked"] = false;

    	return fullInfo
    end

    private
        def set_audition_entering_date
            if self.audition_date != nil
                self.audition_entering_date = DateTime.now
            end
        end
end