require "test_helper"
require "bayes_classifier"

describe BayesClassifier do
  before do
    @classifier = BayesClassifier.new
    @classifier.train :none, "spam and great spam"
    @classifier.train :match, "good football"
  end

  describe "#classify" do
    it "must recognize matches" do
      @classifier.classify("I love football").must_equal :match
    end

    it "must recognize spam" do
      @classifier.classify("spam is tasty").must_equal :none
    end
  end
end
