require 'spec_helper'

describe "Message Tasks pages" do
  subject { page }

  describe "Index page" do
    before { visit message_tasks_path }

    it { should have_content('Поручения') }
    it { should have_title('Message Tasks') }

    it { should have_css('table#message-tasks-table') }
  end


end