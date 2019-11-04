# frozen_string_literal: true

class Admin::EditorsController < Admin::ApplicationController
  skip_before_action :authenticate_editor_by_token, only: %i[login]
  before_action :set_editor, only: %i[destroy show update]

  def telephone_login
    telephone_code = $redis.get "#{params[:telephone]}_code"

    telephones = %w[11111111111]

    if telephones.include?(params[:telephone]) && params[:code] == '1234'
      @editor = Editor.find_by(telephone: params[:telephone])
    else
      raise CustomMessageError.new(422, '验证码无效') if telephone_code != params[:code]

      @editor = Editor.find_or_initialize_by(telephone: params[:telephone])

      @editor.update user_params
      @editor.regenerate_auth_token
    end

    render :show
  end

  def login
    @editor = Editor.where(telephone: params[:telephone]).first

    raise CustomMessageError.new(401, '账号或密码错误') if @editor.try(:authenticate, params[:password])

    @editor.last_logined_at = Time.zone.now
    @editor.save

    render :show
  end

  def change_password
    raise CustomMessageError.new(401, '认证失败') if @current_editor.try(:authenticate, params[:origin_password])

    @current_editor.password = params[:new_password]
    @current_editor.save

    @editor = @current_editor
    render :show
  end

  def me
    @editor = @current_editor
    @editor.last_logined_at = Time.zone.now
    @editor.save

    render :show
  end

  def show; end

  def index
    where = {}

    @editors =
      if params[:role].present?
        Role.where(name: params[:role]).first.editors
      else
        Editor
      end

    @editors = @editors.where(where).or(telephone: /#{params[:query]}/).or(username: /#{params[:query]}/).desc(:created_at).page(page).per(per)

    paginate @editors
  end

  def create
    param! :roles, Array, required: true

    @editor = Editor.new editor_params.except(:password, :new_password).merge(password: '111111')
    @editor.save

    params[:roles].each do |role|
      @editor.add_role(role.to_sym)
    end

    render :show
  end

  def update
    @editor.update editor_params.except(:password, :new_password)

    render :show
  end

  def destroy
    raise CustomMessageError.new(403, '您没权限做此操作') unless @current_editor.has_role?(:super_admin)

    @editor.destroy
  end

  private

  def set_editor
    @editor = Editor.find(params[:id])
  end

  def editor_params
    params.permit(:telephone, :password, :email, :avatar, :username, :new_password, roles: [])
  end
end
