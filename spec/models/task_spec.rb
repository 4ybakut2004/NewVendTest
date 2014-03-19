require 'spec_helper'

describe Task do
	before { 
		@message = Message.create(:name => "С телефона", :request_type => :phone)
		@task = Task.new(:name => "Починить автомат", :message_id => @message.id) 
	}

  	subject { @task }

  	it { should respond_to(:name) }
  	it { should respond_to(:message_id) }

  	it { should be_valid }

  	describe "when name is not present" do
		before { @task.name = " " }
		it { should_not be_valid }
	end

	describe "when message_id is not present" do
		before { @task.message_id = nil }
		it { should_not be_valid }
	end
end
