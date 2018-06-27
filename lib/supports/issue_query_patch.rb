module Supports
	module IssueQueryPatch

		def initialize_available_filters
				super
				add_available_filter "customer_address", :type => :text
		end
  end
end
