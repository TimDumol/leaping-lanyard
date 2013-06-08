class User < ActiveRecord::Base
  attr_accessible :address, :credit, :email, :latitude, :longitude, :password_digest

  has_secure_password

  geocoded_by :address

  def geocode_or_unset
    if self.residence
      self.geocode
    else
      self.latitude = self.longitude = nil
    end
  end

  after_validation :geocode_or_unset, :if => lambda { |obj| obj.address_changed? }
end