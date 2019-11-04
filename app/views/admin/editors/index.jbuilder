# frozen_string_literal: true

json.array! @editors do |editor|
  json.id editor.id.to_s
  json.extract! editor,
                :telephone,
                :username,
                :email,
                :auth_token,
                :role_names
end
