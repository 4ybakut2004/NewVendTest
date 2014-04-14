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
    	return fullInfo
    end
end