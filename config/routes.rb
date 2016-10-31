Rails.application.routes.draw do
  # Jasmine testing
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  
  # Devise authorization
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
  
  # crud API
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      
      # crud users
      resources :users do
        member do
          # toggle admin role
          post 'toggle_admin'
        end
      end

      # crud tickets
      resources :tickets do
        member do
          # close ticket
          post 'close'
        end

        collection do
          # load report
          get 'report'

          # load options
          get 'statuses'
          get 'categories'
        end
      end
      
    end
  end

  # Root
  root 'home#index'
end
