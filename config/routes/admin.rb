# frozen_string_literal: true

namespace :admin, path: '/admin' do
  resources :articles
  resources :editors
end
