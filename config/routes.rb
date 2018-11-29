# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    # confirmations:      'devise_token_auth/confirmations',
    # passwords:          'devise_token_auth/passwords',
    # omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
    # registrations:      'overrides/registrations',
    # sessions:           'devise_token_auth/sessions',
    # token_validations:  'overrides/token_validations',
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get '/test', to: "proposals#test"
  get '/user/details', to: 'user#details'
  post '/user/new', to: 'user#new_user'
  # get '/token', to: "proposals#test_token"
  get '/get_challenge', to: 'authentication#challenge'
  post '/prove', to: 'authentication#prove'

  get '/transactions/test_server', to: 'transactions#test_server'
  post '/transactions/confirmed', to: 'transactions#confirmed'
  post '/transactions/latest', to: 'transactions#latest'
  post '/transactions/new', to: 'transactions#new'
  post '/transactions/list', to: 'transactions#list'
  post '/transactions/status', to: 'transactions#status'

  scope '/proposals' do
    get '/create', to: 'proposals#create'
    get '/details/:proposalId', to: 'proposals#find'
  end
end
