Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/revenue", to: "revenue#show"
      namespace :merchants do
        get "/:id/revenue", to: "revenue#show"
        get "/:id/items", to: 'items#index'
        get '/find_all', to: 'find#index'
        get "/find", to: "find#show"
        get "/most_revenue", to: "revenue#index"
        get "/most_items", to: "most_items#show"
      end
      namespace :items do
        get "/:id/merchant", to: 'merchants#show'
        get '/find_all', to: 'find#index'
        get "/find", to: "find#show"
      end
      resources :merchants, only: [:index, :show, :create, :update, :destroy]
      resources :items, only: [:index, :show, :create, :update, :destroy]

    end
  end
end
