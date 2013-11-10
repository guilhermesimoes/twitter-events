class TweetCreator
  def self.create(tweet)
    user = find_or_initialize_user(tweet.user)
    place = find_or_initialize_place(tweet.place)
    create_tweet(tweet, user, place)
  end

  def self.find_or_initialize_user(user)
    User.where(remote_id: user.attrs[:id_str]).first_or_initialize do |u|
      u.name = user.name
      u.screen_name = user.screen_name
      u.description = user.description
      u.website_url = user.url.to_s
      u.image_url = user.profile_image_url_https.to_s
      u.location = user.location
      u.followers_count = user.followers_count
      u.created_at = user.created_at
    end
  end

  def self.find_or_initialize_place(place)
    Place.where(remote_id: place.id.to_s).first_or_initialize do |p|
      p.name = place.name
      p.country = place.country
      p.bounding_box_coordinates = place.bounding_box.coordinates[0]
    end
  end

  def self.create_tweet(tweet, user, place)
    Tweet.create do |t|
      t.remote_id = tweet.attrs[:id_str]
      t.text = tweet.text
      t.created_at = tweet.created_at
      t.coordinates = tweet.geo.coordinates if tweet.geo?
      t.user = user
      t.place = place
    end
  end
end
