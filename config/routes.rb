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
  
  #CSVのインポート
  post '/import_csv', to: 'users#import_csv'
  #出勤社員一覧
  get  '/attendance_users',    to: 'users#attendance_users'
  resources :account_activations, only: [:edit]
  resources :attendances
  
  #上長画面一ヶ月分勤怠申請のお知らせフォーム
  get  '/monthly_confirmation_form',    to: 'attendances#monthly_confirmation_form'
  post  '/monthly_confirmation_form',    to: 'attendances#monthly_confirmation_form'
  post  '/monthly_confirmation_status_update',    to: 'attendances#monthly_confirmation_status_update'

  #上長画面勤怠変更申請のお知らせフォーム
  get  '/change_confirmation_form',    to: 'attendances#change_confirmation_form'
  post  '/change_confirmation_form',    to: 'attendances#change_confirmation_form'
  post  '/change_confirmation_status_update',    to: 'attendances#change_confirmation_status_update'

  #上長面残業申請のお知らせフォーム
  get  '/overwork_confirmation_form',    to: 'attendances#overwork_confirmation_form'
  post  '/overwork_confirmation_form',    to: 'attendances#overwork_confirmation_form'
  post  '/overwork_confirmation_status_update',    to: 'attendances#overwork_confirmation_status_update'

  #一ヶ月分の申請
  patch  '/monthly_confirmation',    to: 'attendances#monthly_confirmation'

  #上長モーダルより、申請者の一ヶ月勤怠画面確認
  get  '/monthly_attendance_show',    to: 'attendances#monthly_attendance_show'

  #基本情報の編集
  resources :basic_information
  #拠点情報の修正
  resources :working_places

  #勤怠ログ
  get  '/attendance_logs',    to: 'attendances#attendance_logs'
  post  '/attendance_logs',    to: 'attendances#attendance_logs'

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