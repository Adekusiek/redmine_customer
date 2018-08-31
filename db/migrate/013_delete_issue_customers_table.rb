class DeleteIssueCustomersTable < ActiveRecord::Migration
  def change
    drop_table :issue_customers
    drop_table :customer_enquetes
  end
end
