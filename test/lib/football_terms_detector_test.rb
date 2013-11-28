require "test_helper"
require "football_terms_detector"

describe FootballTermsDetector do
  let(:detector) { FootballTermsDetector }

  describe "::detect" do
    it "must return all the terms matched" do
      detector.detect("What a shot, what a goal!").must_equal ["shot", "goal"]
    end
  end

  describe "::detects?" do
    it "must detect americans" do
      detector.detects?("My favorite sport is soccer").must_equal true
    end

    it "must detect dribbling" do
      detector.detects?("Look at that dribble!").must_equal true
    end

    it "must detect shooting" do
      detector.detects?("What a shot!").must_equal true
    end

    it "must detect enthusiastic fans" do
      detector.detects?("GOOOAAAAAAaaaaaall").must_equal true
    end

    it "must detect demolishing games" do
      detector.detects?("Look at that score!").must_equal true
    end

    it "must detect Ronaldo" do
      detector.detects?("Ronaldo with another hat-trick that guy is Legendary!!!").must_equal true
    end

    it "must detect substitutions" do
      detector.detects?("68' Another substitution for the Turkish side: "\
        "Riera comes on for Amrabat. #RMLive").must_equal true
    end

    it "must do assistant referees' job" do
      detector.detects?("Disallowed ooooooooo Shelveys nose was offside").must_equal true
    end

    it "must detect when the ball crosses the touch-line" do
      detector.detects?("mate watch the highlights, that should not have counted, " \
        "ball went out for a throw in son!").must_equal true
    end

    it "must detect cards" do
      detector.detects?("Red card: #mufc are down to nine men as James Weir " \
        "is shown a second yellow card.").must_equal true
    end

    it "must detect sent off players" do
      detector.detects?("In the 23 years Giggs has been playing for United, "\
        "he has never been sent off for the Reds #mufc").must_equal true
    end

    it "must detect whistling" do
      detector.detects?("And there's the final whistle").must_equal true
    end

    it "must detect history making" do
      detector.detects?("Real Madrid is the first team that has ever scored in 30 " \
        "straight games in the history of the Champions League").must_equal true
    end
  end
end
