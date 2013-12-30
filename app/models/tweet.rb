class Tweet < ActiveRecord::Base
  searchable do
    text :text, :stored => true
    time :created_at
  end

  belongs_to :user
  belongs_to :place
  has_many :references, :dependent => :destroy
  has_many :events, :through => :references

  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }
  scope :any_tags, -> (*tags){ where("tags && ARRAY[?]", tags) }
  scope :all_tags, -> (*tags){ where("tags @> ARRAY[?]", tags) }
  scope :any_named_entities, -> (*named_entities){ where("named_entities && ARRAY[?]", named_entities) }
  scope :all_named_entities, -> (*named_entities){ where("named_entities @> ARRAY[?]", named_entities) }

  def url
    "https://twitter.com/#{user.screen_name}/status/#{twitter_id}"
  end
end
