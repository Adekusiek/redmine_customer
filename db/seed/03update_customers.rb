class UpdateCustomers
  def self.update

    customer_enquetes = CustomerEnquete.all.includes(:customer)
    ActiveRecord::Base.transaction do
      customer_enquetes.each do |customer_enquete|
        customer = customer_enquete.customer
        next if customer.nil?
        customer.update(
          accept_flag: customer_enquete.accept_flag,
          last_reply_date: customer_enquete.last_reply_date
        )
      end
    end
  end

end

UpdateCustomers.update
