class TweetRule < ApplicationRecord

    #Doing so will result in the removal of all tweets that were picked up for the rule being deleted. 
    has_many :tweets, dependent: :destroy 


end
