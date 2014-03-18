require 'spec_helper'

describe "Requests pages" do
  subject { page }

  describe "Index page" do
    before { visit requests_path }

    it { should have_content('Заявки') }
    it { should have_content('Новая заявка') }
    it { should have_title('| Requests') }
  end

end