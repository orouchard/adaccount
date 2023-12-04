Rails.application.routes.draw do
  resources :periods
  resources :params
  resources :products do
    resources :prices, only: %i[ create edit update destroy ], shallow: true
  end
  resources :invoices do
    resources :line_items, only: %i[ create edit update destroy ]
    resources :journals
  end
  resources :journals do
    resources :entries
  end
  resources :users do
    resources :invoices
  end
  resources :accounts

  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "users/wizzard" => "users#wizzard", as: "user_wizzard"
  get "account_sum/:id/:year/:month" => "accounts#month_account_sum", as: "account_sum"
  get "users/categories/:id" => "users#list", as: "users_category"
  get "accounts/:id/toggle" => "accounts#toggle", as: "toggle"
  get "journals/filter/:filter" => "journals#index", as: :filtered_journals
  get "journals/:id/check" => "journals#check", as: :check_journal
  post "journal/:invoice_id/journalwizard" => "journals#wizard", as: :journal_wizard
  post "wizard/:user_id/enrollment" => "wizard#enrollment", as: :wizard_enrollment
  get "wizard/:invoice_id/destroy" => "wizard#destroy", as: :wizard_destroy

  # Defines the root path route ("/")
  root "home#index"
end
