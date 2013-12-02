require "test_helper"
require "analyzed_text"

describe "AnalyzedText" do
  let(:analyzed_text) do
    AnalyzedText.new("Angela Merkel and Nicolas Sarkozy are politicians", NER)
  end

  describe "#entities" do
    it "must return named entities and tags identified by ner" do
      analyzed_text.entities
        .must_equal [["Angela Merkel", "Nicolas Sarkozy"], [:person, :person]]
    end
  end

  describe "#named_entities" do
    it "must return only named entities identified by ner" do
      analyzed_text.named_entities
        .must_equal ["Angela Merkel", "Nicolas Sarkozy"]
    end
  end

  describe "#tags" do
    it "must return only tags identified by ner" do
      analyzed_text.tags.must_equal [:person, :person]
    end
  end
end

class NER
  def self.recognize(text)
    [["Angela Merkel", "Nicolas Sarkozy"], [:person, :person]]
  end
end
