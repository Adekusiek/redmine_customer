module Supports
	module IssuesControllerPatch
		def self.included(base)
			base.send(:include, InstanceMethods)

			base.class_eval do
				unloadable

				alias_method_chain :show, :support
			end
		end

		module InstanceMethods
			def show_with_support

				@issue_customer = IssueCustomer.where(issue_id: @issue.id).first_or_create
				
				return show_without_support
			end
		end
	end
end
