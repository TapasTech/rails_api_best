# frozen_string_literal: true

class Mini::UsersController < Mini::ApplicationController
  before_action :authenticate_user_by_token, only: %i[me bind_telephone update_info tuiyajin]
  before_action :set_user, only: %i[show]
  before_action :jscode2session, only: %i[create grant bind_telephone]

  include Utils::Crawler

  def show; end

  def me
    render :show
  end

  def update_info
    if user_params[:id_code].present?
      raise CustomMessageError.new(422, '请输入正确身份证号码') if user_params[:id_code].size != 18
      raise CustomMessageError.new(422, '您的年纪太大，不应该是学生') if user_params[:id_code][6, 4].to_i < 1990
    end

    @user.update user_params

    render :show
  end

  def create
    param! :code, String, required: true

    raise CustomMessageError.new(422, '您还未授权，请先到个人中心进行授权') if @jscode2session['openid'].blank?

    @user = User.where(mini_open_id: @jscode2session['openid']).first

    raise CustomMessageError.new(422, '您还未授权，请先到个人中心进行授权') if @user.blank?

    render :show
  end

  #   {
  #     "openId": "o9OSZ5WvhhLcvfQxMZU5v_6qCkM4",
  #     "nickName": "听雨声太烦",
  #     "gender": 1,
  #     "language": "zh_CN",
  #     "city": "Songjiang",
  #     "province": "Shanghai",
  #     "country": "China",
  #     "avatarUrl": "https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKqBS9lpuTbY1sfTumcTQNcZGu451tOGYfRYsWFYKaITp8YuDuUL8ZF8JSWUqgaZpntRlRePApqWQ/132",
  #     "unionId": "ollnJ1Jna_80nIpEq6nXXcrOvVLo",
  #     "watermark": {
  #         "timestamp": 1561622297,
  #         "appid": "wxcbc138d20b922c0b"
  #     }
  # }
  def grant
    param! :iv, String, required: true
    param! :code, String, required: true
    param! :encryptedData, String, required: true

    userinfo = Wechat.decrypt(params[:encryptedData], @jscode2session['session_key'], params[:iv])
    
    @user = User.where(wechat_union_id: userinfo['unionId']).first

    if @user.blank?
      @user = User.new user_body(userinfo)
      @user.save
    end

    render :show
  end

  def bind_telephone
    param! :iv, String, required: true
    param! :code, String, required: true
    param! :encryptedData, String, required: true

    userinfo = Wechat.decrypt(params[:encryptedData], @jscode2session['session_key'], params[:iv])

    @user.telephone = userinfo['phoneNumber']
    @user.save

    render :show
  end

  def tuiyajin
    @user.balance += @user.promise_price
    @user.promise_price = 0
    @user.save

    @user.orders.create(
      price: @user.promise_price,
      description: '退押金',
      category: 'tuiyajin'
    )

    render :show
  end

  private

  def jscode2session
    @jscode2session = Wechat.api(:mini).jscode2session(params[:code]).with_indifferent_access
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :telephone)
  end

  def user_body(userinfo)
    {
      username: userinfo['nickName'],
      avatar: aliyun_oss_url(userinfo['avatarUrl']),
      mini_open_id: userinfo['openId'],
      wechat_union_id: userinfo['unionId'],
      gender: userinfo['gender'] == 1 ? '男' : '女',
      country: userinfo['country'],
      province: userinfo['province'],
      city: userinfo['city'],
      language: userinfo['language']
    }
  end
end
