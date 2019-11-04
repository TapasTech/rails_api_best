# frozen_string_literal: true

json.cache! ['v2', Article.desc(:created_at).last.created_at] do
  json.array! @articles do |article|
    json.id article.id.to_s
    json.extract! article, :title, :summary, :author, :visit_times, :created_at
  end
end
