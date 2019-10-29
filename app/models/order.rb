# frozen_string_literal: true

class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  belongs_to :user

  field :code, type: String, default: ''
  field :status, type: String, default: 'unpaid'
  field :category, type: String, default: ''
  field :channel, type: String, default: ''
  field :device, type: String, default: ''
  field :description, type: String, default: ''
  field :price, type: Integer, default: 0

  aasm column: :status do
    state :unpaid, initial: true
    state :paid

    event :pay do
      transitions from: :unpaid, to: :paid
    end
  end
end
