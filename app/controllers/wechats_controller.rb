# frozen_string_literal: true

class WechatsController < ActionController::Base
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  # 当用户加关注
  on :event, with: 'subscribe' do |request|
    wechat_user = wechat.user(request[:FromUserName])

    # {
    #   "subscribe": 1,
    #   "openid": "odrxF5zrHMS1p2c9xz62yPk0GYH0",
    #   "nickname": "听雨声太烦",
    #   "sex": 1,
    #   "language": "zh_CN",
    #   "city": "松江",
    #   "province": "上海",
    #   "country": "中国",
    #   "headimgurl": "http:\/\/thirdwx.qlogo.cn\/mmopen\/D3fjhy3ibPUTFbM0iccMTp0oriawXMQUrWIqLicEvrbnIvla7pnJDq6LIcibmhQELF7wNvgo80lusdTM4hSeDFD1rQhQ9evmlfNql\/132",
    #   "subscribe_time": 1555059196,
    #   "unionid": "oL4Xhwkr6gtkQyTHolW25Gq8cWzs",
    #   "remark": "",
    #   "groupid": 0,
    #   "tagid_list": [],
    #   "subscribe_scene": "ADD_SCENE_SEARCH",
    #   "qr_scene": 0,
    #   "qr_scene_str": ""
    # }

    user = User.where(wechat_union_id: wechat_user['unionid']).first_or_create!

    user_body = {
      username: wechat_user['nickname'],
      avatar: AliyunOssService.new.aliyun_oss_url(wechat_user['headimgurl']),
      wechat_open_id: wechat_user['openid'],
      wechat_union_id: wechat_user['unionid'],
      gender: wechat_user['sex'] == 1 ? '男' : '女',
      country: wechat_user['country'],
      province: wechat_user['province'],
      city: wechat_user['city'],
      language: wechat_user['language']
    }

    user.update!(user_body)

    request.reply.text '感谢你关注我们的公众号'
  end

  on :text do |request, content|
    request.reply.text "echo: #{request[:FromUserName]} #{content}" # Just echo
  end
end
