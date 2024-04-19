require 'rails_helper'

RSpec.describe CompanySerializer do
  let(:company) { create(:company) }

  it "serializes the company" do
    actual = CompanySerializer.new(company).call
    expected = {
      name: company.name,
      industry: company.industry,
      employee_count: company.employee_count,
      total_deal_amount: company.calculate_total_deal_amount
    }
    expect(actual).to eq(expected)
  end
end
