class TweetSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :coordinates
  has_one :user
  has_one :place

  def id
    object.twitter_id
  end
end
