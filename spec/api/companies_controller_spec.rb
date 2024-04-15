require 'rails_helper'

RSpec.describe "Companies", type: :request do
  before do
    5.times { create(:company) }
    15.times { create(:deal, company_id: Company.order("RAND()").first.id) }
  end

  describe "GET /index" do
    let(:companies_endpoint) { "/api/v1/companies" }

    it "returns http success" do
      get companies_endpoint

      expect(response.status).to eq(200)
    end

    it "returns paginated results" do
      page = 2
      per_page = 2
      
      get "#{companies_endpoint}?page=#{page}&per_page=#{per_page}"
      json_response = JSON.parse(response.body)
      
      expect(json_response.class).to eq(Hash)
      expect(json_response["page"]).to eq(page)
      expect(json_response["per_page"]).to eq(per_page)
      expect(json_response["records"].class).to eq(Array)
      expect(json_response["records"].length).to eq(per_page)
    end

    it "returns companies list with deals" do
      get companies_endpoint

      json_response = JSON.parse(response.body)
      expected_data = Company.order(created_at: :desc).as_json(include: :deals)
      expect(json_response["records"]).to eq(expected_data)
    end

    context "with filters" do
      let(:selected_company_name) { Company.last.name }
      let(:selected_industry_name) { Company.first.industry }
      let(:selected_employee_count) { Company.order(employee_count: :desc).first.employee_count - 1 }
      let(:selected_deals_amount) { Company.find_by(name: selected_company_name).deals.sum(:amount) - 1 }
      let(:companies_data) { JSON.parse(response.body)["records"] }

      it 'filtering by name' do
        get "#{companies_endpoint}?company_name=#{selected_company_name}"

        expect(companies_data.length).to eq(1)
        expect(companies_data.first["name"]).to eq(selected_company_name)
      end

      it 'filtering by industry' do
        get "#{companies_endpoint}?industry_name=#{selected_industry_name}"

        expect(companies_data.length).to eq(1)
        expect(companies_data.first["industry"]).to eq(selected_industry_name)
      end

      it 'filtering by minimum employee count GREATER' do
        get "#{companies_endpoint}?min_employee_count=#{selected_employee_count}"

        expect(companies_data.length).to eq(1)
        expect(companies_data.first["employee_count"]).to be >= selected_employee_count
      end
      it 'filtering by minimum employee count EQUAL' do
        get "#{companies_endpoint}?min_employee_count=#{selected_employee_count}"

        expect(companies_data.length).to eq(1)
        expect(companies_data.first["employee_count"]).to eq(selected_employee_count + 1)
      end
    end
  end
end
