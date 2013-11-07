require 'twitter_client'
require 'sse'

class TweetsController < ApplicationController
  include ActionController::Live

  def index
    twitter_client = TwitterClient.create
    # Coordinates of Portugal's bounding box
    coordinates = %w(-9.580936 36.949892 -6.340828 41.983994)
    conditions = {
      :locations => coordinates.join(","),
      :language => "pt"
    }

    sse = SSE.new(response.stream)
    response.headers["Content-Type"] = "text/event-stream"

    begin
      twitter_client.filter(conditions) do |tweet|
        sse.write({:user => tweet.user.screen_name, :tweet => tweet.text})
        sleep 1
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end
end
