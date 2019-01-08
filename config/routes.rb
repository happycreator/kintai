Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :attendances
  get  '/attendance_users',    to: 'users#attendance_users'
  resources :basic_information
  
  # 出勤画面表示・編集
  get  '/attendance_update', to: 'attendances#attendance_update'
  post '/attendance_update', to: 'attendances#attendance_update'
  patch '/attendance_update', to: 'attendances#attendance_update'


  get  '/attendance_edit', to: 'attendances#attendance_edit'
  post '/attendance_edit', to: 'attendances#attendance_edit'
  patch '/attendance_edit', to: 'attendances#attendance_edit'
  
  post  '/attendance_update_all', to: 'attendances#attendance_update_all'
  get   '/attendance_update_all', to: 'attendances#attendance_update_all'
end