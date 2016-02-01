class User < ActiveRecord::Base
  has_many :ratings
  has_many :beers, through: :ratings

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3 }
  validates :username, length: { maximum: 15 }

  include RatingAverage
end
