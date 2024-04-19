require 'rails_helper'

RSpec.describe CompaniesFinder do
  let(:companies_scope) { Company.order(created_at: :desc) }

  before do
    5.times { create(:company) }
    15.times { create(:deal, company_id: Company.order("RAND()").first.id) }
  end

  it "returns companies list" do
    actual = CompaniesFinder.companies_index_scope
    expected = companies_scope
    expect(actual).to match_array(expected)
  end

  context "with filters" do
    let(:filters) { {} }
    let(:result) { CompaniesFinder.companies_index_scope(filters) }

    context 'filtering by name' do
      let(:filters) { { company_name: selected_company_name} }
      let(:selected_company_name) { Company.last.name }

      it 'returns filtered results' do
        expect(result.length).to eq(1)
        expect(result.first[:name]).to eq(selected_company_name)
      end
    end

    context 'filtering by industry' do
      let(:filters) { { industry_name: selected_industry_name} }
      let(:selected_industry_name) { Company.last.industry }

      it 'returns filtered results' do
        expect(result.length).to eq(1)
        expect(result.first["industry"]).to eq(selected_industry_name)
      end
    end

    context 'filtering by minimum employee count' do
      let(:filters) { { min_employee_count: selected_employee_count} }
      let(:selected_employee_count) { Company.order(employee_count: :desc).first.employee_count }

      it 'returns filtered results' do
        expect(result.length).to be < Company.count
        expect(result.first["employee_count"]).to be >= selected_employee_count
      end
    end

    context 'filtering by minimum deal amount' do
      let(:filters) { { min_deal_amount: selected_deal_amount} }
      let(:selected_deal_amount) { Company.with_total_deal_amount.order(total_deal_amount: :desc).first.total_deal_amount }

      it 'returns filtered results' do
        expect(result.length).to be < Company.count
        expect(result.first["total_deal_amount"]).to be >= selected_deal_amount
      end
    end
  end
end
