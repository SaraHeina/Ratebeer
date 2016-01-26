class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average_rating
    sum = self.ratings.map { |r| r.score }
    sum.sum/sum.count.to_f
  end

  def to_s
    self.name + ", " + self.brewery.name
  end

end
