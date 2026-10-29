Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "patients",        to: "pages#patients"
  get "professionnels",  to: "pages#professionnels"
  get "hopital",         to: "pages#hopital"
  get "carte",           to: "pages#carte"
  get "annuaire",                 to: "pages#annuaire",        as: :annuaire
  get "patients/trouver-mon-cmp", to: "pages#trouver_mon_cmp", as: :trouver_mon_cmp

  resources :etp_programs, path: "etp", only: [:index, :show]
  resources :news, path: "actualites", only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
