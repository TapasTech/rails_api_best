# frozen_string_literal: true

class AliyunOssService
  def aliyun_oss_url(image_path)
    key = SecureRandom.hex(16)

    file_path = '/tmp/article_image_url.png'

    data = open(image_path, &:read)

    open(file_path, 'wb') { |f| f.write(data) }

    $bucket.put_object(key, file: file_path)

    "#{Settings.aliyun.oss.domain}/#{key}"
  end
end
