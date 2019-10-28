# frozen_string_literal: true

concern :CommonErrorPlugin do
  included do
    rescue_from CustomMessageError, with: :error_4xx
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActionController::ParameterMissing, with: :error_422
    rescue_from ActiveRecord::RecordNotFound, with: :error_404
    rescue_from AASM::InvalidTransition, with: :error_422
    rescue_from RailsParam::Param::InvalidParameterError, with: :error_401
  end

  private

  def error_validate(e)
    render json: { message: e.summary.split(':')[1] }.to_json, status: :misdirected_request
  end

  def render_unprocessable_entity_response(exception)
    message = exception.record.errors.full_messages.join("\n")
    render json: { message: message }, status: :unprocessable_entity
  end

  def error_4xx(e)
    render json: { message: e.message }.to_json, status: e.status
  end

  def error_404(e)
    render json: { message: e.message }.to_json, status: :not_found
  end

  def error_422(e)
    render json: { message: e.message }.to_json, status: :unprocessable_entity
  end

  def error_401(e)
    render json: { message: e.message }.to_json, status: :unauthorized
  end
end
