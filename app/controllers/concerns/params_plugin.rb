# frozen_string_literal: true

concern :ParamsPlugin do
  def page
    params[:page].to_i || 1
  end

  def per
    params[:per].to_i.zero? ? 10 : params[:per].to_i
  end

  def paginate(data)
    @pagination =
      if data.try(:current_page).present?
        {
          current_page: data.current_page,
          total_pages: data.total_pages,
          next_page: data.next_page,
          total_count: data.total_count,
          per: per
        }
      end
  end
end
