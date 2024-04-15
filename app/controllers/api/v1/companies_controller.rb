class Api::V1::CompaniesController < Api::BaseController
  def index
    companies = Company.order(created_at: :desc)
    companies = companies.with_total_deal_amount
    companies = apply_filtering(companies)
    render json: paginated(companies)
  end

  private

  def apply_filtering(companies)
    companies = companies.where('LOWER(companies.name) LIKE LOWER(?)', "%#{params[:company_name]}%") if params[:company_name].present?
    companies = companies.where('LOWER(industry) LIKE LOWER(?)', "%#{params[:industry_name]}%") if params[:industry_name].present?
    min_employee_count = params[:min_employee_count]
    if min_employee_count.present? && min_employee_count.to_i.to_s == min_employee_count
      companies = companies.where('employee_count >= ?', min_employee_count)
    end
    min_deal_amount = params[:min_deal_amount]
    if min_deal_amount.present? && min_deal_amount.to_i.to_s == min_deal_amount
      companies = companies.having('total_deal_amount >= ?', min_deal_amount)
    end
    companies
  end
end
