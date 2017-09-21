# module Supports
# 	module IssuesControllerPatch
# 		def self.included(base)
# 			base.send(:include, InstanceMethods)
#
# 			base.class_eval do
# 				unloadable
#
# 				alias_method_chain :show, :support
# 			end
# 		end
#
# 		module InstanceMethods
# 			def show_with_support
#
# 				@issue_customer = IssueCustomer.where(issue_id: @issue.id).first_or_create
#
# 				return show_without_support
# 			end
# 		end
# 	end
# end

module Supports
	module IssuesControllerPatch
		def show
			@issue_customer = IssueCustomer.where(issue_id: @issue.id).first_or_create
			super
		end

		def update
			super
			  logger.info("I'm called from Issues Controller Patch update method") if logger
				issue = Issue.find(params[:id])
				today = Date.today
				return if !params[:attachments]
				i = params[:attachments].length
				for num in 1..i do
						attachment = Attachment.find_by(container_id: params[:id], filename: params[:attachments][:"#{num.to_s}"][:filename])
						original_path = attachment.diskfile
						dir = "//10.1.1.100/public/FSI/10_CustomerSupport/#{issue.subject}/#{today}/"
						FileUtils::mkdir_p dir
			      FileUtils.cp(original_path, dir + attachment.filename)
						puts attachment.diskfile
				end
		end
	end
end
