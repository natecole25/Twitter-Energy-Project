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




    #Simply displays the button for beginning to stream tweets
    def start_streaming_tweets
        
    end

    def stream
        system(python stream.py)
        flash[:notice] = "streaming has begun"
    end

    def show_rules
        @rules = TweetRule.all
        #@rules_url = "https://api.twitter.com/2/tweets/search/stream/rules"
        #response = HTTParty.get(@rules_url, headers: {"Authorization" => "Bearer #{ENV['bearer_token']}"})
        #@rules = JSON.parse(response.body)
    end

    def delete_rule
        rule = TweetRule.find(params[:format])
        value = rule.value
        id = rule.rule_id
        category = rule.category
        if rule.destroy()
            flash[:notice] = "Rule was successfully deleted"
            #If saved to the model need to save it to the api
            body_post = { "delete": {
                "ids": [
                  "#{id}"
                ]
              }
            }.to_json()

            @rules_url = "https://api.twitter.com/2/tweets/search/stream/rules"
            HTTParty.post(@rules_url, headers:{"Content-type" => "application/json", "Authorization" => "Bearer #{ENV['bearer_token']}"}, body: body_post)
            redirect_to rules_path
        else
            flash[:alert] = "The rule could not be deleted. Please try again later."
            redirect_to rules_path
        end
    end


    def new
        #Needed to prevent form error
        @tweet = Tweet.new()
    end


    def create_remotely
        tweet = Tweet.new(tweet_id: params[:tweet_id], tweet_text: params[:tweet_text], tag: params[:tag], retweet_count: params[:retweet_count], date_tweeted: params[:date_tweeted])
        rule = TweetRule.find_by(category: tweet.tag)
        tweet.update(tweet_rule_id: rule.id)

        if tweet.save
            render json: tweet, status: :created
        else 
            render json: tweet.errors, status: :unprocessable_entity
        end
    end

    def handle_new_rule
        value = params[:value].to_s
        category = params[:tag].to_s
        rule = TweetRule.new(value: value, category: category)
        #If saved to the model need to save it to the api
        body_post = { "add": [
            {
            "value": value,
            "tag": category
            }]
        }.to_json()

        @rules_url = "https://api.twitter.com/2/tweets/search/stream/rules"
        response = HTTParty.post(@rules_url, headers:{"Content-type" => "application/json", "Authorization" => "Bearer #{ENV['bearer_token']}"}, body: body_post)
        
       
        official_id = response.body['data'][0]['id']


        if rule.save() && response.code == 201
            flash[:notice] = "This rule was successfully saved"
            rule.update(rule_id: official_id)
            redirect_to rules_path
        else
            flash[:alert] = "This rule could not be saved. Please try again"
            redirect_to new_rule_path
        end
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