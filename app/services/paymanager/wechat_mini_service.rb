# frozen_string_literal: true

module Paymanager
  class WechatMiniService
    WECHAT_NOTIFY_URL = 'https://127.0.0.1/orders/wechat_mini_notify'

    def initialize
      WxPay.appid = Settings.wechat_mini.appid
      WxPay.key = Settings.wechat_business_wxpub.secret
      WxPay.mch_id = Settings.wechat_business_wxpub.mch_id
      WxPay.extra_rest_client_options = { timeout: 2, open_timeout: 3 }
      pkcs12_filepath = "#{Rails.root}/#{Settings.wechat_business_wxpub.mch_cert_p12_path}"
      WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), Settings.wechat_business_wxpub.mch_id.to_s)
    end

    def pay(body, out_trade_no, price, wechat_open_id)
      body = {
        body: body,
        out_trade_no: out_trade_no,
        total_fee: (price * 100).to_i,
        spbill_create_ip: '127.0.0.1',
        notify_url: WECHAT_NOTIFY_URL,
        trade_type: 'JSAPI',
        openid: wechat_open_id
      }

      prepay_result = WxPay::Service.invoke_unifiedorder body

      params = {
        prepayid: prepay_result['prepay_id'],
        noncestr: prepay_result['nonce_str']
      }

      WxPay::Service.generate_js_pay_req params
    end

    def webhook(result)
      WxPay::Sign.verify?(result)
    end

    def withdraw(wechat_open_id, residue, desc)
      transfer = {
        partner_trade_no: SecureRandom.hex(16),
        openid: wechat_open_id,
        check_name: 'NO_CHECK',
        amount: (residue * 100).to_i,
        desc: desc,
        spbill_create_ip: '127.0.0.1'
      }

      prepay_result = WxPay::Service.invoke_transfer transfer

      raise CustomMessageError.new(422, prepay_result['err_code_des'].to_s) if prepay_result['result_code'] == 'FAIL'
    end

    def pay_bank(bank_name, bank_username, bank_card_number, partner_trade_no, pirce, desc)
      public_key = OpenSSL::PKey::RSA.new(WxPay::Service.risk_get_public_key['pub_key'])

      enc_bank_no = Base64.strict_encode64(public_key.public_encrypt(bank_card_number, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING))
      enc_true_name = Base64.strict_encode64(public_key.public_encrypt(bank_username, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING))
      bank_code = bank_name.split('-')[1].to_i

      result = WxPay::Service.pay_bank(
        partner_trade_no: partner_trade_no,
        enc_bank_no: enc_bank_no,
        enc_true_name: enc_true_name,
        bank_code: bank_code,
        amount: (pirce * 100).to_i,
        desc: desc
      )

      raise CustomMessageError.new(422, result[:raw]['xml']['err_code_des']) if result[:raw]['xml']['result_code'] != 'SUCCESS' || result[:raw]['xml']['return_msg'] != '支付成功'
    end

    def query_bank(partner_trade_no)
      result = WxPay::Service.query_bank(partner_trade_no: partner_trade_no)

      return result[:raw]['xml']['return_msg'] if result[:raw]['xml']['result_code'] == 'FAIL'

      case result[:raw]['xml']['status']
      when 'PROCESSING'
        '处理中'
      when 'SUCCESS'
        '付款成功'
      when 'FAILED'
        '付款失败'
      when 'BANK_FAIL'
        '银行退票'
      end
    end
  end
end
