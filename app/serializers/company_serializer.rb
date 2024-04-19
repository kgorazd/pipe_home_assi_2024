class CompanySerializer
  attr_reader :company

  def initialize(company)
    @company = company
  end

  def call
    {
      name: company.name,
      industry: company.industry,
      employee_count: company.employee_count,
      total_deal_amount: total_deal_amount
    }
  end

  private

  def total_deal_amount
    if company.respond_to?(:total_deal_amount)
      company.total_deal_amount
    else
      company.calculate_total_deal_amount
    end
  end
end
