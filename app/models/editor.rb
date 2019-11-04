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
  field :email, type: String, default: ''
  field :username, type: String, default: ''

  field :avatar, type: String, default: ''
  field :auth_token, type: String, default: ''

  before_save do
    puts 'editor before_save'
  end

  after_create do
    puts 'editor after_create'
  end

  def role_names
    roles.pluck(:name)
  end
end
