class RequestTask < ActiveRecord::Base
    include ActiveModel::Dirty

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
        fullInfo["machine_name"] = request_message.request.machine.name
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

    def self.assign_filter
        "executor_id IS NULL OR deadline_date IS NULL"
    end

    def self.execute_filter
        "execution_date IS NULL"
    end

    def self.audit_filter
        "execution_date IS NULL AND deadline_date < '#{DateTime.now}' OR execution_date IS NOT NULL AND audition_date IS NULL"
    end

    def self.to_assign_count(assigner)
        filter = {}
        filter[("assigner_id").to_sym] = assigner.id
        return RequestTask.where(filter).where(RequestTask.assign_filter).size
    end

    def self.to_execute_count(executor)
        filter = {}
        filter[("executor_id").to_sym] = executor.id
        return RequestTask.where(filter).where(RequestTask.execute_filter).size
    end

    def self.to_audit_count(auditor)
        filter = {}
        filter[("auditor_id").to_sym] = auditor.id
        return RequestTask.where(filter).where(RequestTask.audit_filter).size
    end

    def self.to_read_assign_count(assigner)
        filter = {}
        filter[("assigner_id").to_sym] = assigner.id
        filter[("is_read_by_assigner").to_sym] = false
        return RequestTask.where(filter).size
    end

    def self.to_read_execute_count(executor)
        filter = {}
        filter[("executor_id").to_sym] = executor.id
        filter[("is_read_by_assigner").to_sym] = true
        filter[("is_read_by_executor").to_sym] = false
        return RequestTask.where(filter).size
    end

    def self.to_read_audit_count(auditor)
        filter = {}
        filter[("auditor_id").to_sym] = auditor.id
        filter[("is_read_by_assigner").to_sym] = true
        filter[("is_read_by_executor").to_sym] = true
        filter[("is_read_by_auditor").to_sym] = false
        return RequestTask.where(filter).size
    end

    def needs_send_execute_email
        (self.deadline_date_changed? || self.executor_id_changed? || self.auditor_id_changed?) &&
        (self.deadline_date && self.executor_id && self.auditor_id)
    end

    def needs_send_audit_email
        self.execution_date_changed? && self.execution_date && self.auditor_id
    end

    private
        def set_audition_entering_date
            if self.audition_date != nil
                self.audition_entering_date = DateTime.now
            end
        end
end