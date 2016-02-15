class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships, source: :user


  def to_s
    name
  end
end
