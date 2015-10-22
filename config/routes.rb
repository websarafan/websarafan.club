Rails.application.routes.draw do
  get '/pls-take-my-money/hayatt' => 'home#pay_hayatt', product: :hayatt
  get '/pls-take-my-money/mailchimp' => 'home#pay_mailchimp', product: :mailchimp
  get '/pls-take-my-money/inst7steps' => 'home#pay_inst7steps', product: :inst7steps
  get '/pls-take-my-money/fb-sales' => 'home#pay_fb_sales', product: :fb_sales
  get '/pls-take-my-money/finance' => 'home#pay_finance', product: :finance
  get '/pls-take-my-money/:product(::code)' => 'home#pay', as: :payment, constraints: { product: /vk_(live|records)|fb_six|b2bsales|linkedin_sales|fb2015_(live|records)/, code: /(#{Query[:partners_codes].join('|')})/ }
  get '/payment' => 'home#pay_adv', as: :payment_adv
  get '/thank-u' => 'home#thank'
  get '/welcome' => 'home#welcome'
  # %w/marketing entrepreneurs/.each do |landing|
  #  get "/#{landing}" => "home##{landing}"
  # end
  get '/speakers' => 'home#speakers'
  get '/schedule' => 'home#schedule'
  get '/speakers/:name' => 'speakers#show', as: :speaker
  get '/privacy' => 'home#privacy', as: :privacy
#  get '/marketing-:code' => 'home#marketing', constraints: { code: /(#{Query[:partners_codes].join('|')})/ }
  get '/protected' => 'assets#index'
  get '/protected/query' => 'assets#say_it'
  get '/chance-for-you' => 'home#redesign'
  get '/conference' => 'home#conference'
  get '/facebook2015' => 'home#facebook2015', as: :last_course
  get '/conference-:code' => 'home#conference', constraints: { code: /(#{Query[:partners_codes].join('|')})/ }
  post '/ym' => 'ym#receiver'
  resources :webinars, only: [:index, :show]
  root to: redirect('/facebook2015')
end
