# frozen_string_literal: true

class Admin::SmsController < Admin::ApplicationController
  skip_before_action :authenticate_editor_by_token

  def create
    param! :telephone, String, required: true

    SecurityCodeService.new(params[:telephone]).invoke
  end
end
