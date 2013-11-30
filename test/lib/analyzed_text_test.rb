require "test_helper"
require "analyzed_text"

describe "AnalyzedText" do
  let(:analyzed_text) do
    AnalyzedText.new("Angela Merkel met Nicolas Sarkozy on January 25th in " \
      "Berlin to discuss a new austerity package.",
      MerkelDetector
    )
  end

  describe "#keywords" do
    it "must find keywords using the injected detector" do
      analyzed_text.keywords.must_equal ["Merkel"]
    end
  end

  describe "#has_keywords?" do
    it "must be true if there are keywords" do
      analyzed_text.has_keywords?.must_equal true
    end
  end

  describe "#has_relevant_entities?" do
    it "must be true if a person is detected" do
      analyzed_text.has_relevant_entities?.must_equal true
    end
  end
end

class MerkelDetector
  def self.detect(text)
    text.scan(/Merkel/)
  end
end
