Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  get "up" => "rails/health#show", as: :rails_health_check

  root "welcome#index"
  
  get ":nick_name", to: "users#show"
  post '/lanugage/change', to: 'language#change'
  
  resources :welcome
  
  resources :tags do
    member do
      get "articles"
    end
  end
    
  resources :profile, only: [] do
    collection do
      get "my_published_articles"
      get "my_draft_articles"

      get "my_comments"
      get "my_rejected_comments"
      get "my_pending_comments"
      get "my_approved_comments"
      
      get "my_received_comments"
      get "my_received_rejected_comments"
      get "my_received_approved_comments"
      get "my_received_pending_comments"
    end
  end

  resources :articles, except: %i[index] do
    member do
      post "publish"
      post "unpublish"
      post "like"
      post "dislike"
      get "likes"
    end

    collection do
      get "search"
    end

    resources :comments do
      member do
        post "mark_as_approved"
        post "mark_as_rejected"
        post "mark_as_pending"
      end
    end
  end

  namespace "api" do
    resources :articles, only: %i[show index]
  end
end
