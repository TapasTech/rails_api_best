# frozen_string_literal: true

module Paymanager
  class WechatAppService
    WECHAT_NOTIFY_URL = 'https://127.0.0.1/orders/wechat_app_notify'

    def initialize
      WxPay.appid = Settings.wechat_open.appid
      WxPay.key = Settings.wechat_business_app.secret
      WxPay.mch_id = Settings.wechat_business_app.mch_id
      WxPay.extra_rest_client_options = { timeout: 2, open_timeout: 3 }
      pkcs12_filepath = "#{Rails.root}/#{Settings.wechat_business_app.mch_cert_p12_path}"
      WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), Settings.wechat_business_app.mch_id.to_s)
    end

    def withdraw(app_open_id, residue, desc)
      transfer = {
        partner_trade_no: SecureRandom.hex(16),
        openid: app_open_id,
        check_name: 'NO_CHECK',
        amount: (residue * 100).to_i,
        desc: desc,
        spbill_create_ip: '127.0.0.1'
      }

      prepay_result = WxPay::Service.invoke_transfer transfer

      raise CustomMessageError.new(422, prepay_result['err_code_des'].to_s) if prepay_result['result_code'] == 'FAIL'
    end

    def pay(body, out_trade_no, price)
      body = {
        body: body,
        out_trade_no: out_trade_no,
        total_fee: (price * 100).to_i,
        spbill_create_ip: '127.0.0.1',
        notify_url: WECHAT_NOTIFY_URL,
        trade_type: 'APP'
      }

      prepay_result = WxPay::Service.invoke_unifiedorder body

      params = {
        prepayid: prepay_result['prepay_id'],
        noncestr: prepay_result['nonce_str']
      }

      result = WxPay::Service.generate_app_pay_req params

      partnerId = result.delete(:partnerId).to_s
      result.merge(partnerId: partnerId)
    end

    def webhook(result)
      WxPay::Sign.verify?(result)
    end
  end
end
