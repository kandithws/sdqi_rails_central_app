Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin/data_dashboard', as: 'rails_admin'
  # get 'toll_fee_record/index'

  # get 'toll_fee_record/create'

  devise_for :users

  resources :cars

  get 'home/index', as: 'index'

  get 'user_dashboard/dashboard', to: 'user_dashboard#dashboard', as: 'dashboard'

  get 'user_dashboard/edit', to: 'user_dashboard#edit', as: 'user_dashboard_edit'
  patch  'user_dashboard/update/:user_id', to: 'user_dashboard#update', as: 'user_dashboard_update'
  get 'user_dashboard/upload_driving_license', to: 'user_dashboard#upload_driving_license', as: 'upload_driving_license'
  patch  'user_dashboard/upload_driving_license/:user_id', to: 'user_dashboard#update_driving_license', as: 'update_driving_license'

  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end