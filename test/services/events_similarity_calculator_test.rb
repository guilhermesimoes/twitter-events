require "test_helper"

describe EventsSimilarityCalculator do
  let(:calculator) { EventsSimilarityCalculator }

  describe "#similar?" do
    it "must return true when data is equal" do
      # Liverpool game tomorrow
      e1 = Event.new(
        :started_at => "[2013-12-07T00:00:00+00:00,2013-12-08T00:00:00+00:00)",
        :actors => { "Liverpool" => 1 }
      )
      e2 = e1
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when teams match and time periods overlap but do not exactly match" do
      # @JasunPotter are you going 2 the Newcastle game on Saturday?
      e1 = Event.new(
        :started_at => "[2013-12-07T00:00:00,2013-12-08T00:00:00)",
        :actors => { "Newcastle" => 1}
      )
      # @Persie_Official is RVP fit for Newcastle game this weekend
      e2 = Event.new(
        :started_at => "[2013-12-07T00:00:00,2013-12-09T00:00:00)",
        :actors => { "Newcastle" => 1}
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when there is one team in common (out of two) and the time periods overlap but do not exactly match" do
      # Going Fulham v Manchester City game this weekend and Aguero gets injured... My luck is poor
      e1 = Event.new(
        :started_at => "[2013-12-21T00:00:00,2013-12-23T00:00:00)",
        :actors => { "Fulham" => 1, "Manchester City" => 1 }
      )
      # Rather excited for Fulham away on Saturday. Negredo hat trick.
      e2 = Event.new(
        :started_at => "[2013-12-21T00:00:00,2013-12-22T00:00:00)",
        :actors => { "Fulham" => 1 }
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when there is one team in common (out of two) and the time periods are close" do
      # Anyone know a site I can stream football on this afternoon? Wanna see the Liverpool game!
      e1 = Event.new(
        :started_at => "[2013-12-07T13:00:00+00:00,2013-12-07T17:00:00+00:00)",
        :actors => { "Liverpool" => 1 }
      )
      # With a bottle of 'Life on the Hedge' sloe vodka, I'm now fully prepared for the Liverpool v West Ham game!
      e2 = Event.new(
        :started_at => "[2013-12-07T14:41:58+00:00,2013-12-07T14:41:59+00:00)",
        :actors => { "Liverpool" => 1, "West Ham" => 1 }
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when there are two teams in common (out of three) and the time periods are close" do
      # "Now the game we've all been waiting for. The clash of the titans. Yep, it's Hull v Stoke."
      e1 = Event.new(
        :started_at => "[2013-12-14T16:56:05+00:00,2013-12-14T16:56:06+00:00)",
        :actors => { "Hull" => 1, "Stoke" => 1 }
      )
      # "Proper glamour game for SNF on Sky tonight. Hull v Stoke. #MouthWatering"
      e2 = Event.new(
        :started_at => "[2013-12-14T00:00:00+00:00,2013-12-15T00:00:00+00:00)",
        :actors => { "SNF" => 1, "Hull" => 1, "Stoke" => 1 }
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return true when there is one team in common (out of five) and the time periods are close" do
      # "Going to the Liverpool Cardiff game on Saturday"
      e1 = Event.new(
        :started_at => "[2013-12-21T00:00:00+00:00,2013-12-22T00:00:00+00:00)",
        :actors => { "Liverpool" => 1, "Cardiff" => 1 }
      )
      # Join us for football tomorrow - 12:45pm Liverpool v Cardiff, 3pm Man Utd v West Ham and Millwall v Middlesborough at 5:15pm #Football
      e2 = Event.new(
        :started_at => "[2013-12-21T00:00:00+00:00,2013-12-22T00:00:00+00:00)",
        :actors => { "Liverpool" => 1, "Cardiff" => 1, "West Ham" => 1, "Millwall" => 1, "Middlesborough" => 1 }
      )
      calculator.new(e1, e2).similar?.must_equal true
    end

    it "must return false when teams match but the times periods are spaced apart (including consecutive days)" do
      # "Going to the Liverpool Cardiff game on Saturday"
      e1 = Event.new(
        :started_at => "[2013-12-21T00:00:00+00:00,2013-12-22T00:00:00+00:00)",
        :actors => { "Liverpool" => 1, "Cardiff" => 1 }
      )
      # @SkySportsNews the Liverpool v Cardiff game as now moved to the Sunday
      e2 = Event.new(
        :started_at => "[2013-12-22T00:00:00+00:00,2013-12-23T00:00:00+00:00)",
        :actors => { "Liverpool" => 1, "Cardiff" => 1 }
      )
      calculator.new(e1, e2).similar?.must_equal false
    end

    it "must return false when there is only one team in common (out of three) and the time periods overlap" do
      # Going to the Chelsea vs Swansea match next week
      e1 = Event.new(
        :started_at => "[2013-12-22T00:00:00,2013-12-29T00:00:00)",
        :actors => { "Chelsea" => 1, "Swansea" => 1 }
      )
      # Can't wait for the Arsenal vs Chelsea next week!
      e2 = Event.new(
        :started_at => "[2013-12-22T00:00:00,2013-12-29T00:00:00)",
        :actors => { "Arsenal" => 1, "Chelsea" => 1 }
      )
      calculator.new(e1, e2).similar?.must_equal false
    end
  end
end
