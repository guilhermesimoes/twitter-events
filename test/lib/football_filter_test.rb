require "test_helper"
require "football_filter"

describe FootballFilter do
  let(:filter) { FootballFilter }

  describe "#ok?" do
    it "must detect americans" do
      analysed_text = OpenStruct.new({
        :text => "I'm going to watch some soccer tomorrow!! Go Arsenal!",
        :tags => [:date, :organization]
      })
      filter.new(analysed_text).game?.must_equal true
    end

    it "must detect enthusiastic fans" do
      analysed_text = OpenStruct.new({
        :text => "GOOOAAAAAAaaaaaall! Rooney!",
        :tags => [:person]
      })
      filter.new(analysed_text).highlight?.must_equal true
    end

    it "must detect player achievements" do
      analysed_text = OpenStruct.new({
        :text => "Ronaldo with another hat-trick that guy is Legendary!!!",
        :tags => [:person]
      })
      filter.new(analysed_text).highlight?.must_equal true
    end

    it "must do assistant referees' job" do
      analysed_text = OpenStruct.new({
        :text => "Disallowed ooooooooo Shelveys nose was offside",
        :tags => [:person]
      })
      filter.new(analysed_text).highlight?.must_equal true
    end

    it "must detect cards" do
      analysed_text = OpenStruct.new({
        :text => "Red card: #mufc are down to nine men as James Weir " \
          "is shown a second yellow card.",
        :tags => [:person]
      })
      filter.new(analysed_text).highlight?.must_equal true
    end

    it "must detect teams" do
      analysed_text = OpenStruct.new({
        :text => "Can't wait for the match between Arsenal and Manchester City.",
        :tags => [:organization, :organization]
      })
      filter.new(analysed_text).teams?.must_equal true
    end
  end
end
