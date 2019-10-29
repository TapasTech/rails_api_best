# frozen_string_literal: true

concern :AuthenticationPlugin do
  def authenticate_user_by_token
    @user = User.where(auth_token: request_token).first

    raise CustomMessageError.new(401, '认证失败') if @user.blank?
  end

  def authenticate_editor_by_token
    @current_editor = Editor.where(auth_token: request_token).first

    raise CustomMessageError.new(401, '认证失败') if @current_editor.blank?
  end

  def request_token
    request.headers['Authorization'] || request.params[:auth_token]
  end
end
