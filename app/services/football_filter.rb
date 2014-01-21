class FootballFilter
  GAME = /\b(?:soccer|football|match(?:es)?|games?|derb(?:y|ies)|league|champions)\b/i.freeze

  HIGHLIGHT = /\b(?:
    yellow\ card|red\ card|offside|free\ kick|penalt(?:y|ie)|g+o+a+l+|
    hat(?:\ |-)?trick|
    first\ half|second\ half|final\ whistle
  )s?\b/ix.freeze

  # :number, :ordinal, :cardinal, :quantity, :money, :percent, :o

  def initialize(analysed_text)
    @text = analysed_text.text
    @tags = analysed_text.tags
  end

  def ok?
    game? or teams? or highlight?
  end

  def game?
    one_team_detected? and date_detected? and detects?(GAME)
  end

  def teams?
    two_teams_detected? and detects?(GAME)
  end

  def highlight?
    (person_detected? or one_team_detected?) and detects?(HIGHLIGHT)
  end

  private

  def date_detected?
    @tags.grep(:date).size > 0
  end

  def two_teams_detected?
    number_of_teams_detected > 1
  end

  def one_team_detected?
    number_of_teams_detected > 0
  end

  def person_detected?
    @tags.include?(:person)
  end

  def number_of_teams_detected
    @number_of_teams_detected ||= @tags.grep(:location).size + @tags.grep(:organization).size
  end

  def detects?(pattern)
    !(pattern =~ @text).nil?
  end
end
