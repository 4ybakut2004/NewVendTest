require 'spec_helper'

describe Message do
  	before { 
		@message = Message.create(:name => "С телефона", :request_type => :phone)
	}

  	subject { @message }

  	it { should respond_to(:name) }
  	it { should respond_to(:request_type) }

  	it { should be_valid }

  	describe "when name is not present" do
		before { @message.name = " " }
		it { should_not be_valid }
	end

	describe "when message_id is not present" do
		before { @message.request_type = nil }
		it { should_not be_valid }
	end
end
