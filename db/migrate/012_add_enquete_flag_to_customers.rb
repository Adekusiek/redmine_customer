class AddEnqueteFlagToCustomers < ActiveRecord::Migration
  def up
    add_column :customers, :accept_flag, :boolean, default: true
    add_column :customers, :last_reply_date, :date,  default: Date.today.prev_year
  end
end
