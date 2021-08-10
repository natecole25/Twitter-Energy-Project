Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'tweets', to: 'tweets#show'
  get 'retweets', to: 'tweets#retweets'
  get 'likes', to: 'tweets#likes'

  root to:  'tweets#chart'

end
