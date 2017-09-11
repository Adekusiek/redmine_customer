class CreateIssueCustomers < ActiveRecord::Migration
  def change
    create_table :issue_customers do |t|
      t.integer :issue_id
      t.integer :customer_id
      t.integer :license_id
    end
  end
end
