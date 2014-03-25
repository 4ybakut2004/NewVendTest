require 'spec_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Новый Вендинг') }
    it { should have_title('New Vending') }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Помощь') }
    it { should have_title('| Help') }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Главная"
    expect(page).to have_title('New Vending')
    click_link "Помощь"
    expect(page).to have_title('Help')

    visit root_path
    first(:link, "Заявки").click
    expect(page).to have_title('| Requests')

    visit root_path
    first(:link, "Автоматы").click
    expect(page).to have_title('| Machines')

    visit root_path
    first(:link, "Типы сигналов").click
    expect(page).to have_title('| Messages')

    visit root_path
    first(:link, "Типы поручений").click
    expect(page).to have_title('| Tasks')

    visit root_path
    first(:link, "Поручения").click
    expect(page).to have_title('| Message Tasks')

    visit root_path
    first(:link, "Мои поручения").click
    expect(page).to have_title('| Message Tasks')
  end

end