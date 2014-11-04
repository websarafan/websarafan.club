Rails.application.routes.draw do
  get '/pls-take-my-money' => 'home#pay', product: :live
  get '/pls-take-my-money/:product' => 'home#pay', as: :payment, defaults: { product: 'live' }, constraints: { product: /(live|records)/}

  get '/payment' => 'home#pay_adv', as: :payment_adv

  get '/thank-u' => 'home#thank'
  get '/welcome' => 'home#welcome'
  %w/marketing entrepreneurs/.each do |landing| 
    get "/#{landing}" => "home##{landing}"
  end
  get '/speakers' => 'home#speakers'
  get '/schedule' => 'home#schedule'
  get '/speakers/:name' => 'speakers#show', as: :speaker
  get '/privacy' => 'home#privacy', as: :privacy
  root 'home#index'  
end
