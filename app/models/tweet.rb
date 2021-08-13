class Tweet < ApplicationRecord
    validates :tweet_id, presence: true
    validates :tweet_text, presence: true
    validates :retweet_count, presence: true
    validates :date_tweeted, presence: true
    validates :tag, presence: true

    #Produced from the ruby twitter gem 
    def self.produce_client
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "dQxn4q3wW1NToR1qt1lk2I3Jc"
            config.consumer_secret     = "9IAwAw9Bk52wWyUcmCb9yw5adPcnt8EpvSFbdHo3eXOpz4EJno"
            config.access_token        = "1420094938012868609-UJ5kAQqXZWhWTiZpCQKlDP2na6FpcB"
            config.access_token_secret = "2q6kyj7TLxsFN0kMGItat98f4h0NGRVWiCkCWeUjienUX"
        end
    end
end

