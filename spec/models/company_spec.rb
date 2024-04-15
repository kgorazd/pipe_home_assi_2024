require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '#with_total_deal_amount' do
    before do
      5.times { create(:company) }
      15.times { create(:deal, company_id: Company.order("RAND()").first.id) }
    end

    it 'returns valid total_deal_amount' do
      expected_company = Company.first
      expected_total_deal_amount = expected_company.deals.sum(:amount)
      result = Company.with_total_deal_amount.first
      expect(result.name).to eq(expected_company.name)
      expect(result.total_deal_amount).to eq(expected_total_deal_amount)
    end

    it 'returns 0 as total when no deals available' do
      expected_company = create(:company)
      result = Company.with_total_deal_amount.last
      expect(result.name).to eq(expected_company.name)
      expect(result.total_deal_amount).to eq(0)
    end
  end
end
