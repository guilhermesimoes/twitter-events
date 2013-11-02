class TweetsController < ApplicationController
  include ActionController::Live

  def index
    response.headers["Content-Type"] = "text/event-stream"
    TWITTER.sample do |tweet|
      response.stream.write("#{tweet.text}\n")
      sleep 1
    end
    response.stream.close
  end
end
