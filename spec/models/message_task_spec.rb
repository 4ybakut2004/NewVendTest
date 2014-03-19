require 'spec_helper'

describe MessageTask do	
	before { 
		@user = User.create(name: "Example User", password: "Very Strong Password")
		@message_task = MessageTask.new(:assigner_id => @user.id,
										:executor_id => @user.id,
										:auditor_id => @user.id,
										:description => "Descr") 
	}

  	subject { @message_task }

  	it { should respond_to(:assigner_id) }
  	it { should respond_to(:executor_id) }
  	it { should respond_to(:auditor_id) }
  	it { should respond_to(:description) }
  	it { should respond_to(:creation_date) }
  	it { should respond_to(:execution_date) }
  	it { should respond_to(:audition_date) }

  	it { should be_valid }
end