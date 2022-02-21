Rails.application.routes.draw do
  resources :libraries
  resources :books
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "books#index"
  get 'borrow/(:id)', to: 'books#borrow'
  get 'checkedout/(:id)', to: 'books#checkedout'
  get 'booklog', to: 'books#booklog'

  post 'borrow/(:id)', to: 'books#borrow'
  get 'return/(:id)', to: 'books#return'
  #get 'pay/(:id)', to: 'books#pay'
  get 'notify/(:id)', to: 'books#notify'
  get 'notificationlog', to: 'books#notificationlog'

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
delete 'book/book_destroy_notify/:id', to: 'books#destroy_notify', as: :book_destroy_notify
#  Rails.application.routes.draw do
  resources :libraries
#    mount Sidekiq::Web => '/sidekiq'
#  end

  authenticate :user, lambda {|u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
