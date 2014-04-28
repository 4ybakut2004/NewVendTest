require 'spec_helper'

describe RequestMessage do
  	let(:request_message) { FactoryGirl.create(:request_message) }

  	subject { request_message }

  	it { should respond_to(:request_id) }
  	it { should respond_to(:message_id) }

end
