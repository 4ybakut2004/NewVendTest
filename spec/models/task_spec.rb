require 'spec_helper'

describe Task do
	before { 
		@message = Message.create(:name => "С телефона", :request_type => :phone)
		@task = Task.new(:name => "Починить автомат") 
	}

  	subject { @task }

  	it { should respond_to(:name) }

  	it { should be_valid }

  	describe "when name is not present" do
		before { @task.name = " " }
		it { should_not be_valid }
	end

end
