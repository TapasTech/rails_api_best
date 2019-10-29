# frozen_string_literal: true

require 'aliyun/oss'
require 'aliyun/sts'

oss = Aliyun::OSS::Client.new(
  endpoint: Settings.aliyun.oss.domain,
  access_key_id: Settings.aliyun.access_key.root,
  access_key_secret: Settings.aliyun.access_key_secret.root,
  cname: true
)

$bucket = oss.get_bucket(Settings.aliyun.oss.bucket)

$sts = Aliyun::STS::Client.new(
  access_key_id: Settings.aliyun.access_key.guyifeng,
  access_key_secret: Settings.aliyun.access_key_secret.guyifeng
)
