class Event < ActiveRecord::Base
  has_many :references, :dependent => :destroy
  has_many :tweets, :through => :references

  def self.where_started_at_overlaps(started_at)
    where("started_at && ?", "[#{started_at.begin}, #{started_at.end}]")
  end
end
