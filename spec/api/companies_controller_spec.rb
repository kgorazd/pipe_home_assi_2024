require 'rails_helper'

RSpec.describe "Companies", type: :request do
  before do
    5.times { create(:company) }
    15.times { create(:deal, company_id: Company.order("RAND()").first.id) }
  end

  describe "GET /index" do
    let(:companies_endpoint) { "/api/v1/companies?#{query}" }
    let(:query) { "" }

    let(:companies_data) do
      get companies_endpoint
      JSON.parse(response.body)["records"]
    end

    it "returns http success" do
      get companies_endpoint

      expect(response.status).to eq(200)
    end

    it "returns companies list with deals" do
      expected_data = Company.order(created_at: :desc).with_total_deal_amount.as_json
      expect(companies_data).to eq(expected_data)
    end

    context "with pagination" do
      let(:page) { 2 }
      let(:per_page) { 2 }
      let(:query) { "page=#{page}&per_page=#{per_page}" }

      it "returns paginated results" do
        get companies_endpoint
        json_response = JSON.parse(response.body)
        
        expect(json_response.class).to eq(Hash)
        expect(json_response["page"]).to eq(page)
        expect(json_response["per_page"]).to eq(per_page)
        expect(json_response["records"].class).to eq(Array)
        expect(json_response["records"].length).to eq(per_page)
      end
    end

    context "with filters" do
      let(:companies_endpoint) { "/api/v1/companies?#{query}" }

      context 'filtering by name' do
        let(:query) { "company_name=#{selected_company_name}" }
        let(:selected_company_name) { Company.last.name }

        it 'returns filtered results' do
          expect(companies_data.length).to eq(1)
          expect(companies_data.first["name"]).to eq(selected_company_name)
        end
      end

      context 'filtering by industry' do
        let(:query) { "industry_name=#{selected_industry_name}" }
        let(:selected_industry_name) { Company.last.industry }

        it 'returns filtered results' do
          expect(companies_data.length).to eq(1)
          expect(companies_data.first["industry"]).to eq(selected_industry_name)
        end
      end

      context 'filtering by minimum employee count' do
        let(:query) { "min_employee_count=#{selected_employee_count}" }
        let(:selected_employee_count) { Company.order(employee_count: :desc).first.employee_count }

        it 'returns filtered results' do
          expect(companies_data.length).to be <= Company.count
          expect(companies_data.first["employee_count"]).to be >= selected_employee_count
        end
      end

      context 'filtering by minimum deal amount' do
        let(:query) { "min_deal_amount=#{selected_deal_amount}" }
        let(:selected_deal_amount) { Company.with_total_deal_amount.order(total_deal_amount: :desc).first.total_deal_amount }

        it 'returns filtered results' do
          expect(companies_data.length).to be <= Company.count
          expect(companies_data.first["total_deal_amount"]).to be >= selected_deal_amount
        end
      end
    end
  end
end
