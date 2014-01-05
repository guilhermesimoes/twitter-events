require "twitter_client"
require "analyzed_text"

desc "Fetches tweets from a stream and saves them to the database"
task :save_tweet_stream => :environment do
  classifier = FootballClassifierFactory.new.create

  twitter_client = TwitterClient.create
  twitter_client.filter do |tweet|

    analyzed_text = AnalyzedText.new(tweet.text, tweet.created_at)
    if FootballFilter.new(analyzed_text).ok?
      if classifier.classify(tweet.text) == :match
        puts "#{tweet.text}\n#{tweet.uri}\n"
        p analyzed_text.entities
        puts ""
        tweet = TweetInitializer.init(tweet, analyzed_text)
        tweet.category = "matched"
        tweet.save
      else
        puts "NOPE: #{tweet.text}\n"
        tweet = TweetInitializer.init(tweet, analyzed_text)
        tweet.category = "not_matched"
        tweet.save
      end
    else
      puts "."
    end

  end
end
