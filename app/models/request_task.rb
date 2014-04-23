class RequestTask < ActiveRecord::Base
	belongs_to :task
	belongs_to :request_message

	belongs_to :assigner, :class_name => "Employee", :foreign_key => "assigner_id"
	belongs_to :executor, :class_name => "Employee", :foreign_key => "executor_id"
	belongs_to :auditor, :class_name => "Employee", :foreign_key => "auditor_id"

	def getFullInfo
    	fullInfo = self.attributes
        fullInfo["request_id"] = self.request_message.request_id
        fullInfo["task_name"] = self.task.name
        fullInfo["assigner_name"] = self.assigner_id ? self.assigner.name : nil
        fullInfo["executor_name"] = self.executor_id ? self.executor.name : nil
        fullInfo["auditor_name"] = self.auditor_id ? self.auditor.name : nil
        fullInfo["deadline_date"] = self.deadline_date ? self.deadline_date : nil
        fullInfo["audition_date"] = self.audition_date ? self.audition_date : nil
        fullInfo["execution_date"] = self.execution_date ? self.execution_date : nil
        fullInfo["checked"] = false;

        fullInfo["request"] = self.request_message.request.getFullInfo
        fullInfo["attributes"] = self.request_message.request_attributes.collect { |ra| { :name => ra.attribute.name, :value => ra.value } }

        return fullInfo
    end

    def attrs
    	fullInfo = self.attributes
        fullInfo["request_id"] = self.request_message.request_id
    	fullInfo["task_name"] = self.task.name
    	fullInfo["assigner_name"] = self.assigner_id ? self.assigner.name : nil
    	fullInfo["executor_name"] = self.executor_id ? self.executor.name : nil
    	fullInfo["auditor_name"] = self.auditor_id ? self.auditor.name : nil
        fullInfo["deadline_date"] = self.deadline_date ? self.deadline_date : nil
        fullInfo["audition_date"] = self.audition_date ? self.audition_date : nil
        fullInfo["execution_date"] = self.execution_date ? self.execution_date : nil
        fullInfo["checked"] = false;

    	return fullInfo
    end
end