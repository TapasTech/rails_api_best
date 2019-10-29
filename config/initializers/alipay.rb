# frozen_string_literal: true

$alipay_client = Alipay::Client.new(
  url: Settings.alipay.url,
  app_id: Settings.alipay.app_id,
  app_private_key: Settings.alipay.app_private_key,
  alipay_public_key: Settings.alipay.alipay_public_key
)
# response = @client.page_execut

# https://github.com/chloerei/alipay/blob/master/doc/quick_start_cn.md