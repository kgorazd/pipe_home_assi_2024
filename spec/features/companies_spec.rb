require 'rails_helper'

RSpec.describe "Companies page", type: :feature, js: true, driver: :selenium_chrome_headless do
  let(:comapnies_count) { 2 }
  let(:companies) { Company.order(created_at: :desc) }
  let(:user) { User.create!(login: 'user', password: '123', api_token: 'abc123') }

  before do
    comapnies_count.times { create(:company) }
    4.times { create(:deal, company_id: Company.order("RAND()").first.id) }

    visit '/login'
    within("#form") do
      fill_in 'Username', with: user.login
      fill_in 'Password', with: user.password
      click_button('Submit')
    end
  end

  it "page loads" do
    expect(page).to have_content 'Companies'
    expect(page).to have_content companies.first.name
  end

  it "filtering works" do
    within("#filters") do
      fill_in 'Company Name', with: companies.last.name
    end
    
    expect(page).to have_content companies.last.name
    expect(page).to_not have_content companies.first.name
  end

  context "with multiple pages" do
    let(:comapnies_count) { 15 }

    it "pagination works" do
      expect(page).to have_content companies.first.name
      expect(page).to_not have_content companies.last.name

      find('span', text: '›').click
      
      expect(page).to_not have_content companies.first.name
      expect(page).to have_content companies.last.name
    end
  end
end
