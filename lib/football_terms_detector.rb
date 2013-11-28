class FootballTermsDetector
  PATTERN = /\b(?:
    soccer|football|match|game|cup|league|competition|champions|
    coach|manager|bench|substitut|team|
    player|defender|midfielder|winger|striker|attacker|goalkeeper|goalie|
    referee|offside|throw(?:\ |-)?in|corner|foul|free\ kick|penalty|sent\ off|
    yellow\ card|red\ card|first\ half|second\ half|final\ whistle|
    tackle|pass|assist|cross|dribble|header|shot|
    score|g+o+a+l+|hat(?:\ |-)?trick
  )\w*/ix

  def self.detect(text)
    text.scan(PATTERN)
  end

  def self.detects?(text)
    !(PATTERN =~ text).nil?
  end
end
