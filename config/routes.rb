Rails.application.routes.draw do
  get '/pls-take-my-money' => 'home#pay', as: :payment
  get '/thank-u' => 'home#thank'
  root 'home#index'  
end
