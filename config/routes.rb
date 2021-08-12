Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'tweets', to: 'tweets#show'
  get 'retweets', to: 'tweets#retweets'
  get 'likes', to: 'tweets#likes'
  get 'form_for_tweet_creation', to: 'tweets#form_for_tweet_creation'
  get 'create_tweet', to:  'tweets#create_tweet'

  root to:  'tweets#homepage'

end
