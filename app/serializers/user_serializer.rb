class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :screen_name, :description, :website_url, :image_url,
    :location, :followers_count, :created_at

  def id
    object.twitter_id
  end
end
