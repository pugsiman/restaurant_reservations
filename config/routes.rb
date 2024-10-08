Rails.application.routes.draw do
  resources :reservations, only: %w[create]
  resources :tables, only: [] do
    collection do
      get 'occupied' => 'tables#index'
    end
  end
end
