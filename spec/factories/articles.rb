# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id          :bigint           not null, primary key
#  author      :string
#  content     :text
#  summary     :string
#  title       :string
#  visit_times :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :article do
    title { FFaker::Job.title }
    content { FFaker::HTMLIpsum.body }
    author { FFaker::Book.author }
    summary { FFaker::Book.description }
    visit_times { 3 }
  end
end
