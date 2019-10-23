# frozen_string_literal: true

# == Schema Information
#
# Table name: editors
#
#  id              :bigint           not null, primary key
#  auth_token      :string
#  last_login_at   :date
#  password_digest :string
#  telephone       :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Editor < ApplicationRecord
  rolify
end
