Rails.application.routes.draw do
  resources :books
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "books#index"
  get 'borrow/(:id)', to: 'books#borrow'
  get 'checkedout/(:id)', to: 'books#checkedout'
  get 'booklog', to: 'books#booklog'

  post 'borrow/(:id)', to: 'books#borrow'
  get 'return/(:id)', to: 'books#return'
  get 'pay/(:id)', to: 'books#pay'


  require 'sidekiq/web'
  require 'sidekiq/cron/web'

#  Rails.application.routes.draw do
#    mount Sidekiq::Web => '/sidekiq'
#  end

  authenticate :user, lambda {|u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
