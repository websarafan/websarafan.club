Rails.application.routes.draw do
  get '/pls-take-my-money' => 'home#pay', as: :payment
  get '/thank-u' => 'home#thank'
  get '/speakers' => 'home#speakers'
  root 'home#index'  
end
