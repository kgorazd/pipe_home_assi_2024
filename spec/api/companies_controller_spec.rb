require 'rails_helper'

RSpec.describe "Companies", type: :request do
  before do
    5.times do |i|
      Company.create(
        name: Faker::Company.name,
        industry: Faker::Company.industry,
        employee_count: rand(10..1000)
      )
    end
    
    statuses = ["pending", "won", "lost"]
    
    15.times do |i|
      Deal.create(
        name: "Deal #{i}",
        status: statuses.sample,
        amount: rand(10..1000),
        company_id: Company.order("RAND()").first.id
      )
    end
  end

  describe "GET /index" do
    let(:companies_endpoint) { "/api/v1/companies" }

    it "returns http success" do
      get companies_endpoint

      expect(response.status).to eq(200)
    end

    it "returns companies list with deals" do
      get companies_endpoint

      companies_data = JSON.parse(response.body)
      expect(companies_data.class).to eq(Array)
      expected_data = Company.order(created_at: :desc).as_json(include: :deals)
      expect(companies_data).to eq(expected_data)
    end
  end
end
