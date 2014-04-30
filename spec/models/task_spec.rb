require 'spec_helper'

describe Task do
	let(:task) { FactoryGirl.create(:task) }
  	subject { task }

  	it { should respond_to(:name) }
  	it { should respond_to(:deadline) }
  	it { should respond_to(:solver_id) }

  	it { should be_valid }

  	describe "when name is not present" do
		before { task.name = " " }
		it { should_not be_valid }
	end

end
