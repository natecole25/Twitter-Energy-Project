class TweetsController < ApplicationController
    
    
    def show
        #grabs the twitter client from the Tweet model
        #client = Tweet.produce_client
        #Want to grab an embed code to embed a tweet
        
        
        @df = Daru::DataFrame.from_csv("C:/Users/ncole/OneDrive/Desktop/Twitter Stream Files/Final Policy Tweets.csv")
        @top_tweets = @df.sort(['retweet_count']).last(100)['text'].uniq
    end


    #Very difficult to show graph on page with ajax call. Probably just create navbar.
    def chart
        #returns a dataframe with tweet information which is then passed to be charted
        @df = Daru::DataFrame.from_csv("C:/Users/ncole/OneDrive/Desktop/Twitter Stream Files/Final Policy Tweets.csv")
        @texas = @df.where(@df['tag'].in(['texas policy']))['date'].value_counts
        @general_sentiment = @df.where(@df['tag'].in(['general energy sentiment']))['date'].value_counts
        
        
    end

    def likes
        @df = Daru::DataFrame.from_csv("C:/Users/ncole/OneDrive/Desktop/Twitter Stream Files/Final Policy Tweets.csv")
        @most_like = @df.sort(['like_count']).first(10)
        @likes_value_count = @most_like["tag"].value_counts
        
    end

    def retweets
        @df = Daru::DataFrame.from_csv("C:/Users/ncole/OneDrive/Desktop/Twitter Stream Files/Final Policy Tweets.csv")
        @df_grouped = Daru::DataFrame.from_csv("C:/Users/ncole/OneDrive/Desktop/Twitter Stream Files/Average Retweets by Tag.csv")
        #Try to get average retweets by category
        cats_count = {'texas policy'=> 0, 'california policy' => 0, 'general energy sentiment'=>0}
        cats_retweets = {'texas policy' => 0, 'california policy' => 0, 'general energy sentiment' => 0}
        @df.each do |line|
            if line['tag'] in cats.keys
                cats_count[line['tag']] += 1
                cats_retweets[line['tag']] += line['retweet_count']
            end
        end
        cats_retweets.each do { |key,value| block }
            value = value/cats_count[key]
        end
        return @df, @df_grouped, cats_retweets
    end






end