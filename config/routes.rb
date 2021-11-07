Rails.application.routes.draw do
  root 'rounds#index'
  resources :rounds
  post 'rounds/:id/update_score' => 'rounds#update_score'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
