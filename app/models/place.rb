class Place
  include ActiveModel::Model

  attr_accessor :id, :name, :status, :reviewlink, :proxylink, :blogmap, :street, :city, :state, :zip, :country, :phone, :overall, :imagecount

  def self.rendered_fields
    [:id, :name, :status, :street, :city, :zip, :country, :overall ]
  end

  def self.map_url
   if Rails.env == "development"
     return blogmap
   else
     linkki = :blogmap
     linkki[4] = "s:"
     return linkki
   end
  end
end