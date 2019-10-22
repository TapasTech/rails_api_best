# frozen_string_literal: true

module RequestHelper
  include ActionDispatch::Integration::Runner

  def get_token(user)
    { "Authorization": user.auth_token }
  end

  def query_for_pagination(options = {})
    {
      page: 1,
      per: 25
    }.merge(options).to_query
  end
end
