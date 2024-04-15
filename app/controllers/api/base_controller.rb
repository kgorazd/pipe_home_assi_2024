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

  def paginated(scope, as_json_options = {})
    {
      page: page,
      per_page: per_page,
      total_records_count: total_records_count(scope),
      records: apply_pagination(scope).as_json(as_json_options)
    }
  end

  def total_records_count(scope)
    if scope.to_sql.include?("GROUP BY")
      scope.length
    else
      scope.count
    end
  end
end
