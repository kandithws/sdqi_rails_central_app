Rails.application.routes.draw do
  post 'omise_callback', to: 'omise#omise_callback'

  authenticate :user, lambda { |u| u.admin? } do
    mount Crono::Web, at: '/admin/scheduler'
  end

  devise_for :users
  resources :cars
  get 'home/index'
  get 'user_dashboard/dashboard', to: 'user_dashboard#dashboard', as: 'dashboard'
  get 'user_dashboard/edit', to: 'user_dashboard#edit', as: 'user_dashboard_edit'
  patch  'user_dashboard/update/:user_id', to: 'user_dashboard#update', as: 'user_dashboard_update'
  get 'user_dashboard/upload_driving_license', to: 'user_dashboard#upload_driving_license', as: 'upload_driving_license'
  patch  'user_dashboard/upload_driving_license/:user_id', to: 'user_dashboard#update_driving_license', as: 'update_driving_license'
  post 'api/toll_fee_record/create', to: 'toll_fee_records#create', as: 'create_toll_fee_record'
  resources :toll_fee_records, only: [:index, :show]
  resources :bills, only: [:index, :create, :show]
  patch 'bills/update_slip/:id', to: 'bills#update_slip', as: 'update_slip'
  get 'bills_unconfirmed', to: 'bills#unconfirmed_index', as: 'unconfirmed_bills'
  get 'bills_unconfirmed/:id', to: 'bills#unconfirmed_show', as: 'unconfirmed_bill'
  post 'bills_unconfirmed/:id', to: 'bills#unconfirmed_update', as: 'unconfirmed_bill_update'
  post 'bills_update_barcode/:id', to: 'bills#update_barcode', as: 'bill_barcode_update'
  post 'api/publish_license', to: 'toll_fee_records#create_with_image', as: 'create_with_image'
  get 'export_bill/:id', to: 'bills#export_pdf', as: 'export_pdf'
  # get 'admin/data_dashboard', to: 'home#dummy_rails_admin', as: 'rails_admin' # dummy to fake path when remove rails admin for debug
  mount RailsAdmin::Engine => '/admin/data_dashboard', as: 'rails_admin'
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
