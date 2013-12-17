require "twitter_client"
require "sse"

class TweetsController < ApplicationController
  include ActionController::Live

  def index
    search = TweetSearch.new(params[:q], params[:page]).search
    render json: search.results, meta: { :last_page => search.results.last_page? }
  end

  def stream
    twitter_client = TwitterClient.create

    sse = SSE.new(response.stream)
    response.headers["Content-Type"] = "text/event-stream"

    twitter_client.filter do |tweet|
      tweet = TweetInitializer.create(tweet, { :save => false })
      serialized_tweet = TweetSerializer.new(tweet)
      sse.write(serialized_tweet)
    end
  rescue IOError
    # When the client disconnects, we'll get an IOError on write
  ensure
    sse.close
  end
end
