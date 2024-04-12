class Api::V1::CompaniesController < ApplicationController
  def index
    companies = Company.order(created_at: :desc)
    companies = apply_filtering(companies)
    render json: companies.includes(:deals).as_json(include: :deals)
  end

  private

  def apply_filtering(companies)
    companies = companies.where('LOWER(name) LIKE LOWER(?)', "%#{params[:company_name]}%") if params[:company_name].present?
    companies = companies.where('LOWER(industry) LIKE LOWER(?)', "%#{params[:industry_name]}%") if params[:industry_name].present?
    min_employee_count = params[:min_employee_count]
    if min_employee_count.present? && min_employee_count.to_i.to_s == min_employee_count
      companies = companies.where('employee_count >= ?', min_employee_count)
    end
    companies
  end
end
