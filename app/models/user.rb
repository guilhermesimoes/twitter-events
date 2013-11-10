class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
end
