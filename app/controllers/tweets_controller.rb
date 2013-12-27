require "twitter_client"
require "analyzed_text"
require "football_filter"
require "football_classifier_factory"
require "sse"

class TweetsController < ApplicationController
  include ActionController::Live

  def index
    search = TweetSearch.new(params[:q], params[:page]).search
    render json: search.results, meta: { :last_page => search.results.last_page? }
  end

  def stream
    classifier = FootballClassifierFactory.new.create

    twitter_client = TwitterClient.create

    sse = SSE.new(response.stream)
    response.headers["Content-Type"] = "text/event-stream"

    twitter_client.filter do |tweet|

      analyzed_text = AnalyzedText.new(tweet.text)
      if FootballFilter.new(analyzed_text).ok? && classifier.classify(tweet.text) == :match
        tweet = TweetInitializer.init(tweet, analyzed_text, { :save => false })
        serialized_tweet = TweetSerializer.new(tweet)
        sse.write(serialized_tweet)
      else
        if analyzed_text.tags.size > 1
          puts "NOPE: #{tweet.text}\n"
        else
          puts "."
        end
      end
    end
  rescue IOError
    # When the client disconnects, we'll get an IOError on write
  ensure
    sse.close
  end
end
