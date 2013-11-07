class TweetsController < ApplicationController
  include ActionController::Live

  def index
    response.headers["Content-Type"] = "text/event-stream"

    # topics = %w(coffee tea)
    # portugal_bounding_box_coordinates
    coordinates = %w(-9.580936 36.949892 -6.340828 41.983994)

    conditions = {
      :locations => coordinates.join(","),
      :language => "pt"
      # :track => topics.join(",")
    }

    TWITTER.filter(conditions) do |tweet|
      response.stream.write("#{tweet.user.screen_name} says:\n #{tweet.text}\n\n")
      sleep 1
    end
    response.stream.close
  end
end
