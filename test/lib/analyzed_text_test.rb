require "test_helper"
require "analyzed_text"

describe AnalyzedText do
  describe "ner attributes" do
    before do
      @analyzed_text = AnalyzedText.new(
        "Angela Merkel and Nicolas Sarkozy are politicians",
        AnalyzedTextTest::PoliticiansNER
      )
    end

    describe "#entities" do
      it "must return named entities and tags identified by the ner" do
        @analyzed_text.entities.must_equal [["Angela Merkel", "Nicolas Sarkozy"], [:person, :person]]
      end
    end

    describe "#named_entities" do
      it "must return the identified named entities" do
        @analyzed_text.named_entities.must_equal ["Angela Merkel", "Nicolas Sarkozy"]
      end
    end

    describe "#tags" do
      it "must return the tags of identified named entities" do
        @analyzed_text.tags.must_equal [:person, :person]
      end
    end

    describe "#named_entities_with_tag" do
      it "must return entities tagged with the given tag" do
        @analyzed_text.named_entities_with_tag(:person).must_equal ["Angela Merkel", "Nicolas Sarkozy"]
      end
    end
  end

  describe "time parser dates" do
    before do
      Timecop.freeze(Time.parse("2013-12-4 22:22:56"))
      @analyzed_text = AnalyzedText.new(
        "Arsenal vs Everton on Sunday is a really interesting game now.",
        AnalyzedTextTest::MatchNER
      )
    end

    describe "#dates" do
      it "must return dates identified by the time parser" do
        @analyzed_text.dates.must_equal [
          Time.parse("2013-12-08 12:00:00"), # sunday
          Time.parse("2013-12-04 22:22:56")  # now
        ]
      end
    end

    describe "#date_ranges" do
      it "must return date ranges identified by the time parser" do
        @analyzed_text.date_ranges.must_equal [
          Time.parse("2013-12-08 00:00:00")..Time.parse("2013-12-09 00:00:00"), # sunday
          Time.parse("2013-12-04 22:22:56")..Time.parse("2013-12-04 22:22:57")  # now
        ]
      end
    end

    after do
      Timecop.return
    end
  end
end

module AnalyzedTextTest
  class PoliticiansNER
    def self.recognize(text)
      [["Angela Merkel", "Nicolas Sarkozy"], [:person, :person]]
    end
  end

  class MatchNER
    def self.recognize(text)
      [["Everton", "Sunday", "now"], [:organization, :date, :date]]
    end
  end
end
