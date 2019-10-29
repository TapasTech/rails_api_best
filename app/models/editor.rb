# frozen_string_literal: true

class Editor
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include ActiveModel::SecureToken

  rolify

  index telephone: 1
  index username: 1

  has_secure_token :auth_token

  has_secure_password

  validates :telephone, presence: true, uniqueness: true

  field :telephone, type: String, default: ''
  field :username, type: String, default: ''
  field :password_digest, type: String, default: ''
  field :auth_token, type: String, default: ''
  field :last_login_time, type: ActiveSupport::TimeWithZone

  def access
    roles_name
  end

  def roles_name
    roles.pluck(:name)
  end
end
