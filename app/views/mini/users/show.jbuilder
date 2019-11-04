# frozen_string_literal: true

json.id user.id.to_s
json.extract! @user,
              :created_at,
              :username,
              :email,
              :telephone,
              :mini_open_id,
              :app_open_id,
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
