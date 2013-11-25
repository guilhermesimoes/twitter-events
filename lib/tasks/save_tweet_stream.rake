require "twitter_client"

desc "Fetches tweets from a stream and saves them to the database"
task :save_tweet_stream => :environment do
  twitter_client = TwitterClient.create
  twitter_client.filter do |tweet|
    puts "#{tweet.text}\n#{tweet.uri}\n\n"
    tweet = TweetCreator.create(tweet)
  end
end
