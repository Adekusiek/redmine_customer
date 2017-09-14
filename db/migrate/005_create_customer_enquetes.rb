class CreateCustomerEnquetes < ActiveRecord::Migration
  def change
    create_table :customer_enquetes do |t|
      t.integer :customer_id
      t.boolean :accept_flag, default :True
      t.date :last_reply_date
    end
  end
end
