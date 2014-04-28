require 'spec_helper'

describe Request do
	let(:request) { FactoryGirl.create(:request) }

  	subject { request }

  	it { should respond_to(:description) }
  	it { should respond_to(:request_type_id) }
  	it { should respond_to(:phone) }
  	it { should respond_to(:machine_id) }
  	it { should respond_to(:registrar_id) }
  	it { should respond_to(:request_task_id) }

  	it { should be_valid }

	describe "when machine_id is not present" do
		before { request.machine_id = nil }
		it { should_not be_valid }
	end

	describe "when registrar_id is not present" do
		before { request.registrar_id = nil }
		it { should_not be_valid }
	end
end