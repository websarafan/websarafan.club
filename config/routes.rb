Rails.application.routes.draw do
  get '/pls-take-my-money' => 'home#pay', product: :live
  get '/pls-take-my-money/:product(::code)' => 'home#pay', as: :payment, defaults: { product: 'live' }, constraints: { product: /(live|records)/, code: /(#{Query[:partners_codes].join('|')})/ }

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
  get '/marketing-:code' => 'home#marketing', constraints: { code: /(#{Query[:partners_codes].join('|')})/ }
  get '/protected' => 'assets#index'
  get '/protected/query' => 'assets#say_it'
  get '/chance-for-you' => 'home#redesign', as: :last_course
  resources :webinars, only: [:index, :show]
  root to: redirect('/chance-for-you')
end
