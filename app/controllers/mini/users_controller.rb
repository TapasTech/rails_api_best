# frozen_string_literal: true

class Mini::UsersController < Mini::ApplicationController
  before_action :authenticate_user_by_token, only: %i[me bind_telephone]
  before_action :jscode2session, only: %i[create grant bind_telephone]
  before_action :decode_encrypt_data, only: %i[grant bind_telephone]

  def me
    render :show
  end

  def create
    param! :code, String, required: true

    raise CustomMessageError.new(401, 'openid解析错误') if @jscode2session['openid'].blank?

    @user = User.where(mini_open_id: @jscode2session['openid']).first

    raise CustomMessageError.new(401, '您还未授权，请先到个人中心进行授权') if @user.blank?

    render :show
  end

  def grant
    @user = User.where(wechat_union_id: @userinfo['unionId']).first_or_create!

    @user.update! user_body(@userinfo)

    render :show
  end

  def bind_telephone
    @user.update!(telephone: @userinfo['phoneNumber'])

    render :show
  end

  private

  def decode_encrypt_data
    param! :iv, String, required: true
    param! :code, String, required: true
    param! :encryptedData, String, required: true

    @userinfo = Wechat.decrypt(params[:encryptedData], @jscode2session['session_key'], params[:iv])
  end

  def jscode2session
    @jscode2session = Wechat.api(:mini).jscode2session(params[:code]).with_indifferent_access
  end

  # {
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
  def user_body(userinfo)
    {
      username: userinfo['nickName'],
      avatar: AliyunOssService.new.aliyun_oss_url(userinfo['avatarUrl']),
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
