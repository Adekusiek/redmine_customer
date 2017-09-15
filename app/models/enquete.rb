class Enquete < ActiveRecord::Base
  unloadable
  belongs_to :customer
  belongs_to :issue
  belongs_to :customer_enquete
end
