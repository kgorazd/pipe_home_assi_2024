# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :feature, js: true, driver: :selenium_chrome_headless do
  let(:user) { User.create!(login: 'user', password: '123', api_token: 'abc123') }

  before do
    visit '/login'
  end

  it 'page loads' do
    expect(page).to have_content 'Login'
    expect(page).to have_content 'Username'
    expect(page).to have_content 'Password'
  end

  context 'with valid credentials' do
    it 'login works' do
      within('#form') do
        fill_in 'Username', with: user.login
        fill_in 'Password', with: user.password
        click_button('Submit')
      end

      expect(page).to have_current_path('/')
    end
  end

  context 'with invalid credentials' do
    it 'shows proper message' do
      within('#form') do
        fill_in 'Username', with: 'invalid'
        fill_in 'Password', with: 'invalid'
        click_button('Submit')
      end

      expect(page).to have_content('Invalid credentials')
    end
  end
end
