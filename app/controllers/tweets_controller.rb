class TweetsController < ApplicationController
    
    require 'daru/io/importers/active_record'
    #Need to make sure this data is coming from database rather than spreadsheet
    def show
        
        #@df = Daru::DataFrame.from_activerecord
        #@df.vectors = Daru::Index.new([:date_tweeted, :tweet_id, :tag,	:tweet_text,:retweet_count ])
        #@top_texas_tweets = @df.where(@df[:tag].eq("texas policy")).sort([:retweet_count]).last(10)[:tweet_text].uniq
        #@general_energy_tweets = @df.where(@df[:tag].eq("general energy sentiment")).sort([:retweet_count]).last(10)[:tweet_text].uniq
        
        @client = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['consumer_key']
            config.consumer_secret     = ENV['consumer_secret_key']
            config.access_token        = ENV['access_token']
            config.access_token_secret = ENV['secret_access_token']
        end
        
            
    end

    #Simply displays the button for migration to database
    def form_for_tweet_creation
    end 

    #Simply displays the button for beginning to stream tweets
    def start_streaming_tweets
    end

    #Convert spreadsheet data to database data on onetime basis
    def create_tweet
        @df = Daru::DataFrame.from_excel("C:/Users/ncole/twitter_energy/energypolicy_Energy_Tweets_100.xls")
        @df.vectors = Daru::Index.new([:date, :id,	:tag,	:text,	:retweet_count,	:reply_count,	:like_count,	:quote_count])
        @df.each(:row) do |row|
            Tweet.create(tweet_id: row[:id], date_tweeted: row[:date], tag: row[:tag], tweet_text: row[:text], retweet_count: row[:retweet_count]  )
        end
        redirect_to root_path
    end



    def homepage
    end


    def retweets
    end






end