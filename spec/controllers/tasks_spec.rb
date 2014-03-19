require 'spec_helper'

describe "Tasks pages" do
  subject { page }

  describe "Index page" do
    before { visit tasks_path }

    it { should have_content('Поручения') }
    it { should have_content('Новое поручение') }
    it { should have_title('| Tasks') }
  end

end