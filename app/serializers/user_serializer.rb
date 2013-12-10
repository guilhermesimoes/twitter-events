class UserSerializer < ActiveModel::Serializer
  attributes :id, :twitter_id, :name, :screen_name, :description, :website_url, :image_url,
    :location, :followers_count, :created_at
end
