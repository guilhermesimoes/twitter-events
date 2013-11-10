class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :place

  def url
    "https://twitter.com/#{user.screen_name}/status/#{remote_id}"
  end
end
