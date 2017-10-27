
require 'fileutils'
module Supports
	module IssuesControllerPatch
		def show
			# prepare instances for hook view
			@issue_customer = IssueCustomer.where(issue_id: @issue.id).first_or_create
			@enquete = Enquete.find_by(issue_id: @issue.id)
			# default show controller
			super
		end

		def update
			# default update controller
			super
			# copy attachment file under /redmine/htdocs/temps/docs4upload
			# copied files are then moved to server by batch file
			issue = Issue.find(params[:id])
			today = Date.today
			# if updated without attachment file, escape
			return if !params[:attachments]
			i = params[:attachments].length
			for num in 1..i do
					attachment = Attachment.find_by(container_id: params[:id], filename: params[:attachments][:"#{num.to_s}"][:filename])
					original_path = attachment.diskfile

#						dir = "//10.1.1.100/public/FSI/10_CustomerSupport/#{issue.subject}/#{today}/"
					dir = "C:/Bitnami/redmine-3.4.2-4/apps/redmine/htdocs/tmp/docs4upload/#{issue.subject}/#{today}/"
					FileUtils.mkdir_p(dir)
		      FileUtils.cp(original_path, dir + attachment.filename)
			end
		end
	end
end
