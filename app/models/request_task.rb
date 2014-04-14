class RequestTask < ActiveRecord::Base
	belongs_to :task
	belongs_to :request_message

	belongs_to :assigner, :class_name => "Employee", :foreign_key => "assigner_id"
	belongs_to :executor, :class_name => "Employee", :foreign_key => "executor_id"
	belongs_to :auditor, :class_name => "Employee", :foreign_key => "auditor_id"

	def getFullInfo
    	fullInfo = self.attributes
    	return fullInfo
    end

    def attrs
    	fullInfo = self.attributes
        fullInfo["request_id"] = self.request_message.request_id
    	fullInfo["task_name"] = self.task.name
    	fullInfo["assigner_name"] = self.assigner ? self.assigner.name : nil
    	fullInfo["executor_name"] = self.executor ? self.executor.name : nil
    	fullInfo["auditor_name"] = self.auditor ? self.auditor.name : nil
        fullInfo["deadline_date"] = self.deadline_date ? self.deadline_date.to_s(:db) : nil
        fullInfo["audition_date"] = self.audition_date ? self.audition_date.to_s(:db) : nil
        fullInfo["execution_date"] = self.execution_date ? self.execution_date.to_s(:db) : nil
        fullInfo["checked"] = false;

        fullInfo["attributes"] = self.request_message.request_attributes.collect { |ra| { :name => ra.attribute.name, :value => ra.value } }

    	return fullInfo
    end
end