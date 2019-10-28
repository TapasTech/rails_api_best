# frozen_string_literal: true

class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  index created_at: -1
  index status: 1

  validates :author, presence: true, uniqueness: true

  field :title, type: String, default: ''
  field :author, type: String, default: ''
  field :summary, type: String, default: ''
  field :content, type: String, default: ''
  field :origin_url, type: String, default: ''
  field :picture, type: String, default: ''
  field :visit_times, type: Integer, default: 0
  field :status, type: String

  before_save do
    # debugger
  end
end
