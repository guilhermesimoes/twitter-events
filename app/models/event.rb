class Event < ActiveRecord::Base
  has_many :references, :dependent => :destroy
  has_many :tweets, :through => :references

  def self.where_started_at_overlaps(started_at)
    where("started_at && ?", "[#{started_at.begin}, #{started_at.end})")
  end

  def to_s
    temp = ""
    case actors.keys.length
    when 0
      temp << "There will be some match"
    when 1
      temp << "#{actors.keys.first} will play"
    else
      sorted_actores = actors.sort_by { |_key, value| value }
      temp << "#{sorted_actores[-1][0]} will play against #{sorted_actores[-2][0]}"
    end
    temp << " at #{locations.keys.join(', ')}" unless locations.empty?
    temp << " between #{started_at.begin.to_formatted_s(:long_ordinal)} \
and #{started_at.end.to_formatted_s(:long_ordinal)}" unless started_at.blank?
    temp << "."
    temp
  end
end
