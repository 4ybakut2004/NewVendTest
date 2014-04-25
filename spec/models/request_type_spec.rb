require 'spec_helper'

describe RequestType do
	let(:request_type) { FactoryGirl.create(:request_type) }

	subject { request_type }

	it { should respond_to(:name) }

	it { should be_valid }
end