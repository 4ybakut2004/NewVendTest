require 'spec_helper'

describe "Request Tasks pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit request_tasks_path }

    it { should have_content('Поручения') }
    it { should have_title('Request Tasks') }
  end


end