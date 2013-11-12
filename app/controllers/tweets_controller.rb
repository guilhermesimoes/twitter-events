require 'twitter_client'
require 'sse'

class TweetsController < ApplicationController
  include ActionController::Live

  def index
    twitter_client = TwitterClient.create

    sse = SSE.new(response.stream)
    response.headers["Content-Type"] = "text/event-stream"

    begin
      twitter_client.filter do |tweet|
        serialized_tweet = TweetSerializer.new(TweetCreator.create(tweet))
        sse.write(serialized_tweet)
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end
end
