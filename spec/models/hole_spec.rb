require 'spec_helper'

describe Hole do
	let(:hole) { FactoryGirl.create(:hole) }

	subject { hole }

	it { should respond_to(:code) }

	it { should be_valid }

	describe "when code is not present" do
		before { hole.code = " " }
		it { should_not be_valid }
	end
end