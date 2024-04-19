# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logout', type: :feature, js: true, driver: :selenium_chrome_headless do
  let!(:company) { create(:company) }

  let(:user) { User.create!(login: 'user', password: '123', api_token: 'abc123') }

  it 'logout page redirects to login page' do
    visit '/logout'

    expect(page).to have_current_path('/login')
    expect(page).to have_content 'Login'
    expect(page).to have_content 'Username'
    expect(page).to have_content 'Password'
  end

  context 'user logged in' do
    before do
      visit '/login'
      within('#form') do
        fill_in 'Username', with: user.login
        fill_in 'Password', with: user.password
        click_button('Submit')
      end
    end

    it 'logout works' do
      expect(page).to have_content 'Companies'
      expect(page).to have_content company.name

      visit '/logout'
      visit '/'
      expect(page).to have_content 'Login'
    end
  end
end
