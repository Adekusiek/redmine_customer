class License < ActiveRecord::Base
  unloadable
  has_many :issue_customers
end
