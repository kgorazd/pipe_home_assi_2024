require 'rails_helper'

RSpec.describe "Companies page", type: :feature, js: true, driver: :selenium_chrome do
  before do
    2.times { create(:company) }
    4.times { create(:deal, company_id: Company.order("RAND()").first.id) }
  end

  it "page loads" do
    visit '/'
    
    expect(page).to have_content 'Companies'
    expect(page).to have_content Company.first.name
  end

  it "filtering works" do
    visit '/'
    
    within("#filters") do
      fill_in 'Company Name', with: Company.last.name
    end
    
    expect(page).to have_content Company.last.name
    expect(page).to_not have_content Company.first.name
  end
end
