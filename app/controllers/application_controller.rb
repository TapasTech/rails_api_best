# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParamsPlugin
  include CommonErrorPlugin

  # layout 'layouts/application'

  def not_found
    render json: { message: '接口不存在' }, status: :not_found
  end
end
