require "test_helper"

describe EventsSimilarityCalculator do
  let(:calculator) { EventsSimilarityCalculator }

  describe "#similar?" do
    it "must return true when data is equal" do
      # Liverpool game tomorrow
      e1 = Event.new(
        :started_at => "[2013-12-07T00:00:00+00:00,2013-12-08T00:00:00+00:00)",
        :actors => ["Liverpool"]
      )
      e2 = e1
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when there is one team in common (out of two) and the time periods are close" do
      # Anyone know a site I can stream football on this afternoon? Wanna see the Liverpool game!
      e1 = Event.new(
        :started_at => "[2013-12-07T13:00:00+00:00,2013-12-07T17:00:00+00:00)",
        :actors => ["Liverpool"]
      )
      # With a bottle of 'Life on the Hedge' sloe vodka, I'm now fully prepared for the Liverpool v West Ham game!
      e2 = Event.new(
        :started_at => "[2013-12-07T14:41:58+00:00,2013-12-07T14:41:59+00:00)",
        :actors => ["Liverpool", "West Ham"]
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when there are two teams in common (out of three) and the time periods are close" do
      # "Now the game we've all been waiting for. The clash of the titans. Yep, it's Hull v Stoke."
      e1 = Event.new(
        :started_at => "[2013-12-14T16:56:05+00:00,2013-12-14T16:56:06+00:00)",
        :actors => ["Hull", "Stoke"]
      )
      # "Proper glamour game for SNF on Sky tonight. Hull v Stoke. #MouthWatering"
      e2 = Event.new(
        :started_at => "[2013-12-14T00:00:00+00:00,2013-12-15T00:00:00+00:00)",
        :actors => ["SNF", "Hull", "Stoke"]
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when there is one team in common (out of five) and the time periods are close" do
      # "Going to the Liverpool Cardiff game on Saturday"
      e1 = Event.new(
        :started_at => "[2013-12-21T00:00:00+00:00,2013-12-22T00:00:00+00:00)",
        :actors => ["Liverpool", "Cardiff"]
      )
      # Join us for football tomorrow - 12:45pm Liverpool v Cardiff, 3pm Man Utd v West Ham and Millwall v Middlesborough at 5:15pm #Football
      e2 = Event.new(
        :started_at => "[2013-12-21T00:00:00+00:00,2013-12-22T00:00:00+00:00)",
        :actors => ["Liverpool", "Cardiff", "West Ham", "Millwall", "Middlesborough"]
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return false when teams match but the times periods are spaced apart (including consecutive days)" do
      # "Going to the Liverpool Cardiff game on Saturday"
      e1 = Event.new(
        :started_at => "[2013-12-21T00:00:00+00:00,2013-12-22T00:00:00+00:00)",
        :actors => ["Liverpool", "Cardiff"]
      )
      # @SkySportsNews the Liverpool v Cardiff game as now moved to the Sunday
      e2 = Event.new(
        :started_at => "[2013-12-22T00:00:00+00:00,2013-12-23T00:00:00+00:00)",
        :actors => ["Liverpool", "Cardiff"]
      )
      calculator.new(e1, e2).similar?.must_equal false
    end
  end
end
