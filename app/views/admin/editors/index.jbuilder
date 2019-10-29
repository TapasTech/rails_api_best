# frozen_string_literal: true

json.array! @editors do |editor|
  json.id editor.id.to_s
  json.extract! editor,
                :telephone,
                :username,
                :auth_token,
                :last_logined_at,
                :access,
                :roles
  json.schools editor.schools do |school|
    json.id school.id.to_s
    json.extract! school, :name
  end
end
