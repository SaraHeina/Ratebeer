class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    sum = self.ratings.map { |r| r.score }
    sum.sum/sum.count.to_f
  end

end
