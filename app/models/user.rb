class User < ActiveRecord::Base
  has_many :ratings
  has_many :memberships
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3 }
  validates :username, length: { maximum: 15 }

  PASSWORD_FORMAT = /\A
  (?=.*\d)           # Must contain a digit
  (?=.*[A-Z])        # Must contain an upper case character
/x

  validates :password, length: { minimum: 4 }
  validates :password, format: {with: PASSWORD_FORMAT, message: "must have at least 1 number and 1 big letter" }

  include RatingAverage

  has_secure_password
end
