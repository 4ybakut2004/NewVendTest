require 'spec_helper'

describe "Tasks pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit tasks_path }

    it { should have_content('Типы поручений') }
    it { should have_content('Новый тип поручения') }
    it { should have_title('| Tasks') }
  end

end