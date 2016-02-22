class User < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  scope :is_frozen, -> { where isfrozen:true }
  scope :is_not_frozen, -> { where isfrozen:[nil,false] }

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

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
   favorite :brewery
  end

  def favorite(category)
   return nil if ratings.empty?

   rated = ratings.map{ |r| r.beer.send(category) }.uniq
   rated.sort_by { |item| -rating_of(category, item) }.first.name
  end

  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end


  def self.top(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |b| -(b.average_rating||0)}
    return sorted_by_rating_in_desc_order.first(n)
  end
end
