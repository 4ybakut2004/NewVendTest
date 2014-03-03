require 'spec_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('New Vending') }
    it { should have_title('New Vending') }
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title('| Help') }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Главная"
    expect(page).to have_title('New Vending')
    click_link "Помощь"
    expect(page).to have_title('Help')
  end

end