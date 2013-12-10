class TweetSerializer < ActiveModel::Serializer
  attributes :id, :twitter_id, :text, :created_at, :coordinates
  has_one :user
  has_one :place
end
