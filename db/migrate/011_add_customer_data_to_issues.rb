class AddCustomerDataToIssues < ActiveRecord::Migration
  def up
    add_column :issues, :customer_id, :integer
    add_column :issues, :license_id, :integer
  end
end
