require 'spec_helper'

describe Machine do
	let(:machine) { FactoryGirl.create(:machine) }

	subject { machine }

	it { should_not respond_to(:uid) }
	it { should_not respond_to(:location) }
	it { should_not respond_to(:machine_type) }

	it { should respond_to(:code) }
	it { should respond_to(:name) }
	it { should respond_to(:external_code) }
	it { should respond_to(:sales_location_id) }
	it { should respond_to(:model_id) }
	it { should respond_to(:machine_key) }
	it { should respond_to(:guid) }

	it { should respond_to(:requests) }
	it { should respond_to(:sales_location) }
	it { should respond_to(:model) }

	it { should be_valid }
end
