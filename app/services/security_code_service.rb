# frozen_string_literal: true

class SecurityCodeService
  attr_accessor :telephone

  TEMPLATE = 'SMS_89700123'

  def initialize(telephone)
    @telephone = telephone
  end

  def invoke
    raise CustomMessageError.new(422, '电话号码必须是11位') if telephone.size != 11

    telephone_code = Utils::Random.digital_code(4)

    $redis.set "#{telephone}_code", telephone_code

    $redis.expire("#{telephone}_code", 1800)

    AliyunSmsService.new(telephone, TEMPLATE).invoke('code': telephone_code)
  end
end
