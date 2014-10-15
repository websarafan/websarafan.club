Rails.application.routes.draw do
  get '/pls-take-my-money' => 'home#pay', as: :payment
  get '/thank-u' => 'home#thank'
  get '/speakers' => 'home#speakers'
  get '/schedule' => 'home#schedule'
  get '/speakers/:name' => 'speakers#show'
  root 'home#index'  
end
