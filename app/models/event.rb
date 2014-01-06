class Event < ActiveRecord::Base
  has_many :references, :dependent => :destroy
  has_many :tweets, :through => :references

  def self.where_started_at_overlaps(started_at)
    where("started_at && ?", "[#{started_at.begin}, #{started_at.end})")
  end

  def to_s
    @string_representation ||= begin
      temp = ""
      case actors.length
      when 0
        temp << "There will be some match"
      when 1
        temp << "#{actors[0]} will play"
      when 2
        temp << "#{actors[0]} will play against #{actors[1]}"
      end
      temp << " at #{locations.join(', ')}" unless locations.blank?
      temp << " between #{started_at.begin.to_formatted_s(:long_ordinal)} \
and #{started_at.end.to_formatted_s(:long_ordinal)}" unless started_at.blank?
      temp << "."
      temp
    end
  end
end
