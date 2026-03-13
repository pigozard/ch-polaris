Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "patients", to: "pages#patients"
  get "professionnels", to: "pages#professionnels"

  get "up" => "rails/health#show", as: :rails_health_check
end
