require 'spec_helper'

describe "Machines pages" do
  subject { page }

  describe "Index page" do
    before { visit machines_path }

    it { should have_content('Автоматы') }
    it { should have_title('Machines') }
  end

end