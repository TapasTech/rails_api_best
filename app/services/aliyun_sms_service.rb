# frozen_string_literal: true

class AliyunSmsService
  attr_accessor :sign_name, :telephone, :code, :template

  def initialize(sign_name, telephone, template)
    @sign_name = sign_name
    @telephone = telephone
    @template = template
  end

  def invoke(body)
    Aliyun::CloudSms.configure do |config|
      config.access_key_secret = Settings.aliyun.access_key_secret.root
      config.access_key_id = Settings.aliyun.access_key.root
      config.sign_name = sign_name
    end

    Aliyun::CloudSms.send_msg(telephone, template, body)
  end
end
