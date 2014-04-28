require 'spec_helper'

describe "Machines pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit machines_path }

    it { should have_title('Machines') }

    describe "Content on page" do
      it { should have_content('Автоматы') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'uid') }
      it { should have_selector('thead th', :text => 'Имя') }
      it { should have_selector('thead th', :text => 'Расположение') }
      it { should have_selector('thead th', :text => 'Тип') }
    end
  end

end