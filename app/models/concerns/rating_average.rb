

  module RatingAverage
    extend ActiveSupport::Concern
    def average_rating
      if ratings.count == 0
        return 0
      else
      (ratings.inject(0.0){ |sum, r| sum+r.score } / ratings.count).round(1)
      end
    end
  end
