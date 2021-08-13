module TweetStreamingHelper

    #bearer token for api call
    

    require 'json'
    require "uri"
    require "net/http"

    # The code below sets the bearer token from your environment variables
    # To set environment variables on Mac OS X, run the export command below from the terminal:
    # export BEARER_TOKEN='YOUR-TOKEN'
    @bearer_token = "AAAAAAAAAAAAAAAAAAAAADGGSAEAAAAAVkak8YWkp4Cg8XgFnN2DEZvZ2vg%3DMKYlkaodiAhJXgr0NBcS3TFbCVavEf7hiFIPXj1e52Ijf2qGLF"

    @stream_url = "https://api.twitter.com/2/tweets/search/stream"
    @rules_url = "https://api.twitter.com/2/tweets/search/stream/rules"



    # Add or remove values from the optional parameters below. Full list of parameters can be found in the docs:
    # https://developer.twitter.com/en/docs/twitter-api/tweets/filtered-stream/api-reference/get-tweets-search-stream
    params = {
    "expansions": "attachments.poll_ids,attachments.media_keys,author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id",
    "tweet.fields": "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang",
    # "user.fields": "description",
    # "media.fields": "url", 
    # "place.fields": "country_code",
    # "poll.fields": "options"
    }



    def get_rules
        url = URI("https://api.twitter.com/2/tweets/search/stream/rules")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["Authorization"] = "Bearer AAAAAAAAAAAAAAAAAAAAADGGSAEAAAAAVkak8YWkp4Cg8XgFnN2DEZvZ2vg%3DMKYlkaodiAhJXgr0NBcS3TFbCVavEf7hiFIPXj1e52Ijf2qGLF"
        request["Cookie"] = "guest_id=v1%3A162881244390404899; personalization_id=\"v1_4ee7KlTAWBloX0pjgQuS2g==\""

        response = https.request(request)
        puts JSON.parse(response.read_body)
    end

    # Get request to rules endpoint. Returns list of of active rules from your stream 


    # Post request to add rules to your stream




    # Helper method that gets active rules and prompts to delete (y/n), then adds new rules set in line 17 (@sample_rules)



    def stream_connect_actual
        url = URI("https://api.twitter.com/2/tweets/search/stream?tweet.fields=attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,possibly_sensitive,public_metrics,referenced_tweets,reply_settings,source,text&expansions=")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["Authorization"] = "Bearer AAAAAAAAAAAAAAAAAAAAADGGSAEAAAAAVkak8YWkp4Cg8XgFnN2DEZvZ2vg%3DMKYlkaodiAhJXgr0NBcS3TFbCVavEf7hiFIPXj1e52Ijf2qGLF"
        request["Cookie"] = "guest_id=v1%3A162881244390404899; personalization_id=\"v1_4ee7KlTAWBloX0pjgQuS2g==\""

        response = https.request(request)
        response.on_body do |chunk|
            puts chunk
        end

        #case response
        #   when Net::HTTPSuccess
        #       JSON.parse response.body
        #   when Net::HTTPUnauthorized
        #       {'error' => "#{response.message}: username and password set and correct?"}
        #   when Net::HTTPServerError
        #       {'error' => "#{response.message}: try again later?"}
        #   else
        #       {'error' => response.message}
        #end
        #puts response.code
        #puts response.read_body
    end

    # Connects to the stream and returns data (Tweet payloads) in chunks
    

    # Comment this line if you already setup rules and want to keep them
    #setup_rules

    # Listen to the stream.
    # This reconnection logic will attempt to reconnect when a disconnection is detected.
    # To avoid rate limites, this logic implements exponential backoff, so the wait time
    # will increase if the client cannot reconnect to the stream.
    def time_to_stream
        timeout = 0
        while true
            stream_connect_actual
            sleep 2 ** timeout
            timeout += 1
        end
    end


    

end