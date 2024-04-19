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

  def paginated(scope, serializer)
    paginated_scope = apply_pagination(scope)
    {
      page: page,
      per_page: per_page,
      total_records_count: total_records_count(scope),
      records: CollectionSerializer.new(paginated_scope, serializer).call
    }
  end

  def total_records_count(scope)
    if scope.to_sql.include?("GROUP BY")
      scope.length
    else
      scope.count
    end
  end

  def authorize
    user = User.find_by(api_token: api_token)
    return if user

    if api_token.present?
      render json: {
        error: "Forbidden",
      }, status: 403
      return
    end

    render json: {
      error: "Unauthorized",
    }, status: 401
  end

  def api_token
    params[:api_token]
  end
end
