require 'spec_helper'

describe Machine do
	let(:machine) { FactoryGirl.create(:machine) }

	subject { machine }

	it { should respond_to(:uid) }
	it { should respond_to(:name) }
	it { should respond_to(:location) }
	it { should respond_to(:machine_type) }

	it { should be_valid }
end
