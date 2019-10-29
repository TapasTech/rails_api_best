# frozen_string_literal: true

json.id @editor.id.to_s
json.extract! @editor,
              :telephone,
              :username,
              :auth_token,
              :last_logined_at,
              :access,
              :roles
