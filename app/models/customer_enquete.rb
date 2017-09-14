class CustomerEnquete < ActiveRecord::Base
  unloadable
  belongs_to :customer
end
