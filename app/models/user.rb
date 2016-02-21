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

  def favorite_brewery
    return nil if ratings.empty?
    bre = {}
    ratings.each do |rating|
      bre[rating.beer.brewery] = 0
    end
    ratings.each do |rating|
      bre.keys.each do |brewery|
        if brewery == rating.beer.brewery
          bre[brewery] = bre[brewery] + rating.score
        end
      end
    end
    iso = 0
    tulos = ""
    bre.each do |score|
        if score.last > iso
          iso = score.last
          tulos = score.first.name
        end
    end
    return tulos
  end

  def favorite_style
    return nil if ratings.empty?
    sty = {}
    ratings.each do |rating|
      x = Style.find rating.beer.style_id
      sty[x.name] = 0
    end
    ratings.each do |rating|
      sty.keys.each do |style|
        x = Style.find rating.beer.style_id
        if style == x.name
          sty[style] = sty[style] + rating.score
        end
      end
    end
    iso = 0
    tulos = ""
    sty.each do |score|
      if score.last > iso
        iso = score.last
        tulos = score.first
      end
    end
    return tulos
    end

  def self.top(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |b| -(b.average_rating||0)}
    return sorted_by_rating_in_desc_order.first(n)
  end
end
