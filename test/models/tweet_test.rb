require "test_helper"

describe Tweet do
  describe "#url" do
    it "must return the tweet url on Twitter" do
      user = User.new(:screen_name => "steve")
      tweet = Tweet.new(:twitter_id => "12345", :user => user)
      tweet.url.must_equal "https://twitter.com/steve/status/12345"
    end
  end
end
