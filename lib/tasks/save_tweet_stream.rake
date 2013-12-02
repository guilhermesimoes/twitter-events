require "twitter_client"
require "analyzed_text"
require "football_terms_detector"

desc "Fetches tweets from a stream and saves them to the database"
task :save_tweet_stream => :environment do
  twitter_client = TwitterClient.create
  twitter_client.filter do |tweet|

    text = AnalyzedText.new(tweet.text, FootballTermsDetector)
    if text.has_keywords? and text.has_relevant_entities?
      puts "#{tweet.text}\n#{tweet.uri}\n"
      p text.keywords
      p text.entities
      puts ""
      tweet = TweetInitializer.create(tweet)
      tweet.named_entities = text.named_entities
      tweet.tags = text.tags
      tweet.save
    else
      puts "."
    end
  end
end
