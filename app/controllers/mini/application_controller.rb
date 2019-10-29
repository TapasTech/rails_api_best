# frozen_string_literal: true

class Mini::ApplicationController < ActionController::Base
  layout 'mini/layouts/application'

  include AuthenticationPlugin
  include CommonErrorPlugin
  include ParamsPlugin

  def not_found
    render json: { message: '接口不存在' }, status: :not_found
  end
end
