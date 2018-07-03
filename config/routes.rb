Rails.application.routes.draw do
  devise_for :users
  root to: 'projects#index'
  resources :projects
  resources :companies, only: :update
  resources :financial_filters
  resources :project_versions do
    put :mark_open_tab
    resources :companies do
      collection do
        post :import
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
