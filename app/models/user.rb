# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecureToken

  has_secure_token :auth_token

  field :auth_token, type: String, default: ''
  
  field :username, type: String, default: ''
  field :telephone, type: String, default: ''
  
  field :gender, type: String, default: ''
  field :birthday, type: ActiveSupport::TimeWithZone, default: -> { Time.zone.now }
  field :avatar, type: String, default: ''
  field :country, type: String, default: ''
  field :province, type: String, default: ''
  field :city, type: String, default: ''
  field :language, type: String, default: ''

  field :app_open_id, type: String, default: ''
  field :mini_open_id, type: String, default: ''
  field :wechat_union_id, type: String, default: ''

  field :score, type: Integer, default: 0
  field :balance, type: Float, default: 0.0

  before_save do
    puts 'before_save'
  end

  before_create do
    puts 'before_create'
  end
end
