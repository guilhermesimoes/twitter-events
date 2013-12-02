require "twitter_client"
require "analyzed_text"
require "football_filter"

desc "Fetches tweets from a stream and saves them to the database"
task :save_tweet_stream => :environment do
  twitter_client = TwitterClient.create
  twitter_client.filter do |tweet|

    text = AnalyzedText.new(tweet.text)
    if FootballFilter.new(text).ok?
      puts "#{tweet.text}\n#{tweet.uri}\n"
      p text.entities
      puts ""
      tweet = TweetInitializer.create(tweet)
      tweet.named_entities = text.named_entities
      tweet.tags = text.tags
      tweet.save
    else
      if text.tags.size > 1
        puts "NOPE: #{tweet.text}\n"
      else
        puts "."
      end
    end

  end
end
