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

    context "with filters" do
      let(:selected_company_name) { Company.last.name }
      let(:selected_industry_name) { Company.first.industry }
      let(:selected_employee_count) { Company.order(employee_count: :desc).first.employee_count - 1 }
      let(:selected_deals_amount) { Company.find_by(name: selected_company_name).deals.sum(:amount) - 1 }

      it 'filtering by name' do
        get "#{companies_endpoint}?company_name=#{selected_company_name}"

        companies_data = JSON.parse(response.body)
        expect(companies_data.length).to eq(1)
        expect(companies_data.first["name"]).to eq(selected_company_name)
      end

      it 'filtering by industry' do
        get "#{companies_endpoint}?industry_name=#{selected_industry_name}"

        companies_data = JSON.parse(response.body)
        expect(companies_data.length).to eq(1)
        expect(companies_data.first["industry"]).to eq(selected_industry_name)
      end

      it 'filtering by minimum employee count GREATER' do
        get "#{companies_endpoint}?min_employee_count=#{selected_employee_count}"

        companies_data = JSON.parse(response.body)
        expect(companies_data.length).to eq(1)
        expect(companies_data.first["employee_count"]).to be >= selected_employee_count
      end
      it 'filtering by minimum employee count EQUAL' do
        get "#{companies_endpoint}?min_employee_count=#{selected_employee_count}"

        companies_data = JSON.parse(response.body)
        expect(companies_data.length).to eq(1)
        expect(companies_data.first["employee_count"]).to eq(selected_employee_count + 1)
      end
    end
  end
end
