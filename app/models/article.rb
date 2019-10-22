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

class Article < ApplicationRecord
  validates :author, presence: true
end
