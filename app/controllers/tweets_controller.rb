require 'twitter_client'
require 'sse'

class TweetsController < ApplicationController
  include ActionController::Live

  def index
    search = Tweet.search(:include => [:user, :place]) do
      fulltext params[:search]

      paginate :per_page => 25
    end
    render json: search.results
  end

  def stream
    twitter_client = TwitterClient.create

    sse = SSE.new(response.stream)
    response.headers["Content-Type"] = "text/event-stream"

    twitter_client.filter do |tweet|
      tweet = TweetInitializer.create(tweet, { :save => true })
      serialized_tweet = TweetSerializer.new(tweet)
      sse.write(serialized_tweet)
    end
  rescue IOError
    # When the client disconnects, we'll get an IOError on write
  ensure
    sse.close
  end
end
