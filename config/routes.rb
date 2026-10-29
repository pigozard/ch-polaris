Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "patients",        to: "pages#patients"
  get "professionnels",  to: "pages#professionnels"
  get "hopital",         to: "pages#hopital"
  get "carte",           to: "pages#carte"
  get "annuaire",                 to: "pages#annuaire",        as: :annuaire
  get "patients/trouver-mon-cmp", to: "pages#trouver_mon_cmp", as: :trouver_mon_cmp
  get "patients/preparer-mon-sejour", to: "pages#preparer_mon_sejour", as: :preparer_mon_sejour
  get "patients/mes-droits",          to: "pages#mes_droits",          as: :mes_droits

  resources :etp_programs, path: "etp", only: [:index, :show]
  resources :news, path: "actualites", only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
