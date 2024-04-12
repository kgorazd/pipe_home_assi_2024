require 'rails_helper'

RSpec.describe "Companies page", type: :feature, js: true, driver: :selenium_chrome do
  before :each do
    2.times do |i|
      Company.create(
        name: Faker::Company.name,
        industry: Faker::Company.industry,
        employee_count: rand(10..1000)
      )
    end

    statuses = ["pending", "won", "lost"]
    
    4.times do |i|
      Deal.create(
        name: "Deal #{i}",
        status: statuses.sample,
        amount: rand(10..1000),
        company_id: Company.order("RAND()").first.id
      )
    end
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
