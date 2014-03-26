require 'spec_helper'
require 'sessions_helper'
include SessionsHelper

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Новый Вендинг') }
    it { should have_title('New Vending') }

    it { should have_content('Войти') }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Главная"
    expect(page).to have_title('New Vending')

    visit root_path
    first(:link, "Заявки").click
    expect(page).to have_title('| Requests')

    visit root_path
    first(:link, "Мои заявки").click
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