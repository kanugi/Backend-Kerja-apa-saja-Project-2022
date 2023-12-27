Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/rahasia-qatros', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      get 'region/provinces', to: 'region#provinces'
      get 'region/regencies', to: 'region#regencies'
      get 'region/districts', to: 'region#districts'
      get 'users/get_current_user', to: 'users#get_current_user'
      resources 'users' do
        put 'upload_photo_profile', to: 'users#upload_photo'
        put 'change_password', to: 'users#change_password'
        put 'change_type', to: 'users#change_user_type'
      end
      post 'forgot_password', to: 'users#forgot_password'
      post 'reset_password', to: 'users#reset_password'
      post 'login', to: 'authentication#login'
      post 'update_token', to: 'authentication#update_token'
      resources :jobs do
        get 'workers', to: 'jobs#workers'
      end
      resources :job_applications do
        put 'update_status', to: 'job_applications#update_status'
        put 'accept_worker', to: 'job_applications#accept_worker'
        put 'reject_worker', to: 'job_applications#reject_worker'
      end
      resources :skills, only: [:index, :create]
      delete 'skills', to: 'skills#destroy'
      get 'skills/me', to: 'skills#me'
      resources :check_ins
      resources :progresses
      resources :categories
      get 'transactions', to: 'transactions#index'
      post 'transactions/top_up_points', to: 'transactions#top_up_points'
      post 'transactions/withdraw_points', to: 'transactions#withdraw_points'
      resources :banks
      resources :companies do
        put 'add_member', to: 'companies#add_member'
        put 'remove_member', to: 'companies#remove_member'
        put 'update_member_role', to: 'companies#update_member_role'
      end
      resources :notifications, only: [:index]
      resources :workers, only: [:index, :show, :destroy] do
        put 'request_finish_job', to: 'workers#request_to_finish_job'
        put 'verify_finish_job', to: 'workers#verify_job_finished'
      end
      resources :rooms, only: [:index, :show]
      resources :messages, only: [:index, :create]
      get 'activity_histories', to: 'users#activity_histories'
      resources :user_banks, only: [:index, :show, :create, :update, :destroy]
    end
  end
end

