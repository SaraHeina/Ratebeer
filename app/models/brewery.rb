class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  only_integer: true}
  validate :year_now

  include RatingAverage

  def year_now
    if year
      if year > Date.today.year
        errors.add(:year, "must be less than or equal to #{Date.today.year}")
      end
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end

end
