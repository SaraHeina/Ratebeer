class User < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
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

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    array = [lager, weizen, pale_ale, ipa, porter]
    a = array.sort
    if lager == a.last
      return "Lager"
    elsif weizen == a.last
      return "Weizen"
    elsif pale_ale == a.last
      return "Pale ale"
    elsif ipa == a.last
      return "IPA"
    else
      return "Porter"
      end
  end

  def lager
    summa = 0
    ratings.each do |rating|
      if rating.beer.style == "Lager"
        summa = summa + rating.score
      end
    end
    return summa
  end

  def weizen
    summa = 0
    ratings.each do |rating|
      if rating.beer.style == "Weizen"
        summa = summa + rating.score
      end
    end
    return summa
  end

  def pale_ale
    summa = 0
    ratings.each do |rating|
      if rating.beer.style == "Pale ale"
        summa = summa + rating.score
      end
    end
    return summa
  end

  def ipa
    summa = 0
    ratings.each do |rating|
      if rating.beer.style == "IPA"
        summa = summa + rating.score
      end
    end
    return summa
  end

  def porter
    summa = 0
    ratings.each do |rating|
      if rating.beer.style == "Porter"
        summa = summa + rating.score
      end
    end
    return summa
  end

end
