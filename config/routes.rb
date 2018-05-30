Rails.application.routes.draw do
  devise_for :users
  root to: 'projects#index'
  resources :projects
  resources :project_versions do
    resources :companies do
      collection do
        post :import
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
