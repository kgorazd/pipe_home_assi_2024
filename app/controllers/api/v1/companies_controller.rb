class Api::V1::CompaniesController < Api::BaseController
  before_action :authorize

  def index
    scope = CompaniesFinder.companies_index_scope(filters)
    render json: paginated(scope, CompanySerializer)
  end

  private

  def filters
    params.permit(CompaniesFinder::AVAILABLE_FILTERS)
  end
end
