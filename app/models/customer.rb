class Customer < ActiveRecord::Base
  unloadable
  has_many :issue_customers
end
