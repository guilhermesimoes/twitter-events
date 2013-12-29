require "chronic"

class TimeParser
  def self.get_dates(text)
    Chronic.parse(text)
  end

  def self.get_date_ranges(text)
    Chronic.parse(text, :guess => false)
  end
end
