class CompaniesFinder
  AVAILABLE_FILTERS = %i[company_name industry_name min_employee_count min_deal_amount].freeze

  def self.companies_index_scope(filters = {})
    companies = Company.order(created_at: :desc)
    companies = companies.with_total_deal_amount
    companies = apply_filtering(companies, filters)
  end

  private

  def self.apply_filtering(companies, filters)
    companies = companies.where('LOWER(companies.name) LIKE LOWER(?)', "%#{filters[:company_name]}%") if filters[:company_name].present?
    companies = companies.where('LOWER(industry) LIKE LOWER(?)', "%#{filters[:industry_name]}%") if filters[:industry_name].present?
    min_employee_count = filters[:min_employee_count]
    if min_employee_count.present? && min_employee_count.to_i.to_s == min_employee_count.to_s
      companies = companies.where('employee_count >= ?', min_employee_count)
    end
    min_deal_amount = filters[:min_deal_amount]
    if min_deal_amount.present? && min_deal_amount.to_i.to_s == min_deal_amount.to_s
      companies = companies.having('total_deal_amount >= ?', min_deal_amount)
    end
    companies
  end
end
