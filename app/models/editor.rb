# frozen_string_literal: true

class Editor
  include Mongoid::Document
  rolify
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include ActiveModel::SecureToken

  index telephone: 1
  index username: 1

  has_secure_token :auth_token

  has_secure_password

  has_many :products
  has_many :orders

  validates :telephone, presence: true, uniqueness: true

  field :wallet, type: Float, default: 0.0

  field :mini_open_id, type: String, default: ''

  field :telephone, type: String, default: ''
  field :username, type: String, default: ''
  field :password_digest, type: String, default: ''
  field :auth_token, type: String, default: ''
  field :note, type: String, default: ''
  field :last_login_time, type: ActiveSupport::TimeWithZone

  field :business_name, type: String, default: ''
  field :address, type: String, default: ''
  field :kuaidi, type: String, default: ''

  def access
    roles_name
  end

  def roles_name
    roles.pluck(:name)
  end
end
