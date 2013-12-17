require "twitter_client"
require "analyzed_text"
require "football_filter"

desc "Fetches tweets from a stream and saves them to the database"
task :save_tweet_stream => :environment do
  twitter_client = TwitterClient.create
  twitter_client.filter do |tweet|

    analyzed_text = AnalyzedText.new(tweet.text)
    if FootballFilter.new(analyzed_text).ok?
      puts "#{tweet.text}\n#{tweet.uri}\n"
      p analyzed_text.entities
      puts ""
      tweet = TweetInitializer.init(tweet, analyzed_text, { :save => true })
    else
      if analyzed_text.tags.size > 1
        puts "NOPE: #{tweet.text}\n"
      else
        puts "."
      end
    end

  end
end
