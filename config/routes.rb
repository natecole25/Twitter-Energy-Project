Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'tweets', to: 'tweets#show'
  get 'retweets', to: 'tweets#retweets'
  get 'likes', to: 'tweets#likes'
  get 'form_for_tweet_creation', to: 'tweets#form_for_tweet_creation'
  #get 'create_tweet', to:  'tweets#create_tweet'
  get 'start_streaming_tweets', to: 'tweets#start_streaming_tweets'
  get 'stream', to: 'tweets#stream'
  get 'new_tweet', to:'tweets#new'
  post 'create_tweets', to:'tweets#create'
  post 'create_tweets_remotely', to: 'tweets#create_remotely'
  get 'new_rule', to: 'tweets#new_rule'
  get 'handle_new_rule', to: 'tweets#handle_new_rule'
  get 'rules', to: 'tweets#show_rules'
  get 'save_rules', to:'tweets#save_rules'
  get 'save_rules_one_time', to: 'tweets#save_rules_one_time'
  delete 'rules/', to: 'tweets#delete_rule'

  root to:  'tweets#homepage'

end
