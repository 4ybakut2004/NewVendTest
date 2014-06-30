require 'spec_helper'

describe RequestTask do
  let(:request_task) { FactoryGirl.create(:request_task) }	

	subject { request_task }

	it { should respond_to(:assigner_id) }
	it { should respond_to(:executor_id) }
	it { should respond_to(:auditor_id) }
	it { should respond_to(:description) }
	it { should respond_to(:creation_date) }
	it { should respond_to(:execution_date) }
	it { should respond_to(:audition_date) }
	it { should respond_to(:task_id) }
	it { should respond_to(:deadline_date) }
	it { should respond_to(:registrar_description) }
	it { should respond_to(:assigner_description) }
	it { should respond_to(:executor_description) }
	it { should respond_to(:auditor_description) }
	it { should respond_to(:audition_entering_date) }
	it { should respond_to(:is_read_by_assigner) }
	it { should respond_to(:is_read_by_executor) }
	it { should respond_to(:is_read_by_auditor) }
	it { should respond_to(:email_to_assigner_date) }
	it { should respond_to(:email_to_auditor_date) }
	it { should respond_to(:email_to_executor_date) }

	it { should respond_to(:assigner_sms_code) }
	it { should respond_to(:executor_sms_code) }
	it { should respond_to(:auditor_sms_code) }

	it { should respond_to(:set_assigner_sms_code) }
	it { should respond_to(:set_executor_sms_code) }
	it { should respond_to(:set_auditor_sms_code) }

	it { should be_valid }
end