# frozen_string_literal: true

namespace :mini, path: '/mini' do
  resources :articles
  resources :users, only: [:create] do
    collection do
      get 'me'
      post 'grant'
      post 'bind_telephone'
    end
  end
end
