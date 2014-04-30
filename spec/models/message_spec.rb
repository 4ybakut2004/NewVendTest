require 'spec_helper'

describe Message do
  	let(:message) { FactoryGirl.create(:message) }

  	subject { message }

  	it { should respond_to(:name) }
  	it { should_not respond_to(:employee_id) }
  	it { should respond_to(:description) }

  	it { should be_valid }

  	describe "when name is not present" do
		before { message.name = " " }
		it { should_not be_valid }
	end
end
