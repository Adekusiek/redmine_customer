class IssueCustomer < ActiveRecord::Base
  unloadable
  belongs_to :issue
  belongs_to :license
  belongs_to :customer
end
