require "bayes_classifier"

class FootballClassifierFactory
  MAX_TRAINING_EXAMPLES_PERCENTAGE = 0.9

  def initialize(classifier = BayesClassifier)
    @example_offset = 1
    @classifier = classifier.new
  end

  def create
    train
    @classifier
  end

  def train
    max_training_examples = (MAX_TRAINING_EXAMPLES_PERCENTAGE *
      number_classified_tweets).floor

    text_of_tweets_with_none(max_training_examples).each do |text|
      @classifier.train(:none, text)
    end

    text_of_tweets_with_match(max_training_examples).each do |text|
      @classifier.train(:match, text)
    end

    @example_offset += max_training_examples
  end

  def test
    number_testing_examples = ((1 - MAX_TRAINING_EXAMPLES_PERCENTAGE) *
      number_classified_tweets).floor

    none_percentage = classify_sample_none(number_testing_examples).fdiv number_testing_examples
    puts "Testing #{number_testing_examples} tweets with :none event:"
    puts "Percentage of tweets with :none event rightly classified: #{none_percentage}"

    match_percentage = classify_sample_match(number_testing_examples).fdiv number_testing_examples
    puts "Testing #{number_testing_examples} tweets with :match event:"
    puts "Percentage of tweets with :match event rightly classified: #{match_percentage}"
  end

  private

  def number_classified_tweets
    [tweets_with_none.count, tweets_with_match.count].min
  end

  def tweets_with_none
    Tweet.where(:category => Category::NONE)
  end

  def tweets_with_match
    Tweet.where(:category => Category::MATCH)
  end

  def text_of_tweets_with_none(n)
    tweets_with_none.limit(n).offset(@example_offset).pluck(:text)
  end

  def text_of_tweets_with_match(n)
    tweets_with_match.limit(n).offset(@example_offset).pluck(:text)
  end

  def classify_sample_none(n)
    text_of_tweets_with_none(n).count { |text| @classifier.classify(text) == :none }
  end

  def classify_sample_match(n)
    text_of_tweets_with_match(n).count { |text| @classifier.classify(text) == :match }
  end
end
