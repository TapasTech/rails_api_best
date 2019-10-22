# frozen_string_literal: true

json.id @article.id.to_s
json.extract! @article, :title, :summary, :author, :visit_times, :created_at
