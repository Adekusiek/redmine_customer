class Customer < ActiveRecord::Base
  unloadable
  has_many :issue_customers
  has_one :customer_enquete
end
