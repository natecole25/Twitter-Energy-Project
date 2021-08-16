class TweetsController < ApplicationController
    
    require 'daru/io/importers/active_record'

    #Need to make sure this data is coming from database rather than spreadsheet
    def show
        
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

    def stream
        system(python stream.py)
        flash[:notice] = "streaming has begun"
    end

    def show_rules
        @rules_url = "https://api.twitter.com/2/tweets/search/stream/rules"
        response = HTTParty.get(@rules_url, headers: {"Authorization" => "Bearer #{ENV['bearer_token']}"})
        @rules = JSON.parse(response.body)
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

    def new
        #Needed to prevent form error
        @tweet = Tweet.new()
    end

    def create
        #blog_params found in the private method section below.
        tweet = Tweet.new(tweet_params)

        #Fix datetime
        datetime=DateTime.civil(params[:date_tweeted][:year].to_i, params[:date_tweeted][:month].to_i, params[:date_tweeted][:day].to_i,
        params[:date_tweeted][:hours].to_i,params[:date_tweeted][:minutes].to_i, params[:date_tweeted][:seconds].to_i)
        tweet.date_tweeted = datetime
        
        #validate that tweet saves
        if tweet.save
            #This displays success message at the top of the page
            flash[:notice] = "Tweet was successfully saved."
            #This redirects to show page for blog. Ruby extracts id from @blog instance
            redirect_to root_path
        else
            render 'new'
        end
    end

    def create_remotely
        tweet = Tweet.new(tweet_id: params[:tweet_id], tweet_text: params[:tweet_text], tag: params[:tag], retweet_count: params[:retweet_count], date_tweeted: params[:date_tweeted])


        if tweet.save
            render json: tweet, status: :created
        else 
            render json: tweet.errors, status: :unprocessable_entity
        end
    end

    def handle_new_rule
        #Insert rule handling logic here
    end


    def new_rule
        #Simply displays rule form
    end

    def homepage
    end

    


    def retweets
    end


    private 

    def tweet_params
        #Doing render plain: params will return a hash object recieved from the form through https then need to 'whitelist specific parametsr using .permit'
        params.require(:tweet).permit(:tweet_id, :tweet_text, :tag, :retweet_count, :date_tweeted)
    end







end