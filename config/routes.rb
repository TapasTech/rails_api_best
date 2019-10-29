# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  draw :admin
  draw :mini

  resource :wechat, only: [:show, :create]
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web, at: '/sidekiq'

  root 'home#index'
end
