class RemoveCustomerEnqueteId < ActiveRecord::Migration
  def self.up
    remove_column :enquetes, :customer_enquete_id
  end
end
