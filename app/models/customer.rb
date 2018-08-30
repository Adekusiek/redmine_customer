class Customer < ActiveRecord::Base
  unloadable
  has_many :issues
  
  def full_name
    self.family_name ||= ""
    self.given_name ||= ""
    self.family_name + "\s" + self.given_name
  end
end
