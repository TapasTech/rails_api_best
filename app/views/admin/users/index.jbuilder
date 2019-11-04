# frozen_string_literal: true

json.array! @users do |user|
  json.id user.id.to_s
  json.extract! user,
                :created_at,
                :updated_at,
                :username,
                :telephone,
                :mini_open_id,
                :wechat_union_id,
                :avatar,
                :language,
                :country,
                :province,
                :city,
                :county,
                :gender,
                :birthday,
                :auth_token
end
