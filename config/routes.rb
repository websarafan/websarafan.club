Rails.application.routes.draw do
  get '/pls-take-my-money' => 'home#pay', as: :payment
  get '/payment' => 'home#pay_adv', as: :payment_adv
  get '/thank-u' => 'home#thank'
  get '/welcome' => 'home#welcome'
  %w/marketing entrepreneurs/.each do |landing| 
    get "/#{landing}" => "home##{landing}"
  end
  get '/speakers' => 'home#speakers'
  get '/schedule' => 'home#schedule'
  get '/speakers/:name' => 'speakers#show', as: :speaker
  root 'home#index'  
end
