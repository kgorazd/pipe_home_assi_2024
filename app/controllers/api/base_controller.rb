class Api::BaseController < ApplicationController
  private

  def page
    params[:page]&.to_i || 1
  end

  def per_page
    params[:per_page]&.to_i || Kaminari.config.default_per_page
  end

  def apply_pagination(scope)
    scope.page(page).per(per_page)
  end

  def paginated(scope, options)
    {
      page: page,
      per_page: per_page,
      total_records_count: scope.count,
      records: apply_pagination(scope).as_json(options)
    }
  end
end
