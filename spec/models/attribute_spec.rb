require 'spec_helper'

describe Attribute do
	let(:attribute) { FactoryGirl.create(:attribute) }

  	subject { attribute }

  	it { should respond_to(:name) }
  	it { should respond_to(:attribute_type) }

  	it { should be_valid }
end