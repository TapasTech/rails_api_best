# frozen_string_literal: true

require 'alipay'

module Paymanager
  class AlipayAppService
    ALIPAY_NOTIFY_URL = 'https://127.0.0.1/orders/alipay_notify'

    def pay(body, out_trade_no, price)
      $alipay_client.sdk_execute(
        method: 'alipay.trade.app.pay',
        notify_url: ALIPAY_NOTIFY_URL,
        biz_content: {
          out_trade_no: out_trade_no,
          product_code: 'QUICK_MSECURITY_PAY',
          total_amount: price.to_s,
          subject: body
        }.to_json(ascii_only: true),
        timestamp: Time.zone.now.strftime('%F %T')
      )
    end

    def withdraw(out_trade_no, payee_account, amount)
      response = $alipay_client.execute(
        method: 'alipay.fund.trans.toaccount.transfer',
        biz_content: JSON.generate({
                                     out_biz_no: out_trade_no,
                                     payee_type: 'ALIPAY_LOGONID',
                                     payee_account: payee_account,
                                     amount: amount
                                   }, ascii_only: true)
      )

      result = JSON.parse(response)['alipay_fund_trans_toaccount_transfer_response']

      if result['code'] != '10000'
        if result['sub_code'] == 'PAYEE_NOT_EXIST'
          raise CustomMessageError.new(422, '此支付宝账户不存在')
        elsif result['sub_code'] == 'PAYER_BALANCE_NOT_ENOUGH'
          raise CustomMessageError.new(422, '支付宝余额不足')
        else
          raise CustomMessageError.new(422, result['msg'] + ' ' + result['sub_code'])
        end
      end
    end
  end
end
