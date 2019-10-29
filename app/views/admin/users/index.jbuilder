# frozen_string_literal: true

json.array! @users do |user|
  json.id user.id.to_s
  json.extract! user,
                :created_at,
                :updated_at,
                :username,
                :realname,
                :telephone,
                :wechat_code,
                :realname,
                :mini_open_id,
                :wechat_union_id,
                :avatar,
                :id_code,
                :promise_price,
                :language,
                :country,
                :city_code,
                :province,
                :city,
                :county,
                :gender,
                :birthday,
                :auth_token,
                :school_name,
                :balance
end
