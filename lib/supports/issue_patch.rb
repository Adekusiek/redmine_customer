module Supports
	module IssuePatch
		# has_one :customer, through: :issue_customer

		def customer_address
			customer ? customer.email : nil
		end
  end
end
