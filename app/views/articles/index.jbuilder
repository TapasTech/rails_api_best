# frozen_string_literal: true

json.cache! ['v2', Article.order(:created_at).last.created_at] do
  json.array! @articles do |article|
    json.id article.id
    json.extract! article, :title, :summary, :author, :visit_times, :created_at
  end  
end
