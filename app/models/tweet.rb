class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :place

  scope :any_tags, -> (*tags){ where("tags && ARRAY[?]", tags) }
  scope :all_tags, -> (*tags){ where("tags @> ARRAY[?]", tags) }
  scope :any_named_entities, -> (*named_entities){ where("named_entities && ARRAY[?]", named_entities) }
  scope :all_named_entities, -> (*named_entities){ where("named_entities @> ARRAY[?]", named_entities) }

  def url
    "https://twitter.com/#{user.screen_name}/status/#{twitter_id}"
  end
end
