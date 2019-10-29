# frozen_string_literal: true

json.id @article.id.to_s
json.extract! @article,
              :created_at,
              :show_person_info,
              :start_at,
              :end_at,
              :address,
              :course,
              :photos,
              :gender,
              :description,
              :price,
              :status,
              :publish_wechat_form_id,
              :accept_wechat_form_id,
              :agree_wechat_form_id,
              :sign_wechat_form_id,
              :check_wechat_form_id,
              :school_name
json.user do
  user = @article.user
  json.id user.id.to_s
  json.extract! user, :username, :avatar
end
