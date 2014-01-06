require "test_helper"

describe Event do
  describe "::where_started_at_overlaps" do
    before do
      Event.create(:started_at => Chronic.parse("today", :guess => false))
    end

    it "must not overlap with the end of the passed date (query dependent)" do
      yesterday = Chronic.parse("yesterday", :guess => false)
      Event.where_started_at_overlaps(yesterday).must_be_empty
    end

    it "must not overlap with the end of dates in the db (so ranges must be created with exclusive end)" do
      tomorrow = Chronic.parse("tomorrow", :guess => false)
      Event.where_started_at_overlaps(tomorrow).must_be_empty
    end

    after do
      Event.destroy_all
    end
  end

  describe "#description" do
    describe "when it only has one actor" do
      it "must include it" do
        teams = ["Tottenham"]
        event = Event.new(:actors => teams)
        event.to_s.must_match teams[0]
      end
    end

    describe "when it has two actors" do
      it "must include them" do
        teams = ["Chelsea", "Arsenal"]
        event = Event.new(:actors => teams)
        event.to_s.must_match teams[0]
        event.to_s.must_match teams[1]
      end
    end

    describe "when it has a location" do
      it "must include it" do
        locations = ["Stamford Bridge", "Fulham", "London"]
        event = Event.new(:locations => locations)
        event.to_s.must_match locations[0]
        event.to_s.must_match locations[1]
        event.to_s.must_match locations[2]
      end
    end

    describe "when it has a start date range" do
      it "must include it" do
        started_at = Time.parse("2013-12-08 00:00:00")..Time.parse("2013-12-09 00:00:00")

        event = Event.new(:started_at => started_at)
        event.to_s.must_match started_at.begin.to_formatted_s(:long_ordinal)
        event.to_s.must_match started_at.end.to_formatted_s(:long_ordinal)
      end
    end

    describe "when it has no actors, nor locations nor dates" do
      it "must still return a string" do
        event = Event.new
        event.to_s.must_be_instance_of String
      end
    end
  end
end
