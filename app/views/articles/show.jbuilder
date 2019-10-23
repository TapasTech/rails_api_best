# frozen_string_literal: true

json.id @article.id
json.extract! @article, :title, :summary, :author, :visit_times, :created_at
