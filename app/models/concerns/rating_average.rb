

  module RatingAverage
    extend ActiveSupport::Concern
    def average_rating
      sum = self.ratings.map { |r| r.score }
      sum.sum/sum.count.to_f
    end
  end
