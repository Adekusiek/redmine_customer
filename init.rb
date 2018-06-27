require 'redmine'
require_dependency 'supports/hooks'

Rails.configuration.to_prepare do
	require_dependency 'issues_controller'
	IssuesController.send :prepend, Supports::IssuesControllerPatch

	require_dependency 'mail_handler'
	MailHandler.send :prepend, Supports::MailHandlerPatch

	IssueQuery.send :prepend, Supports::IssueQueryPatch
	Issue.send :prepend, Supports::IssuePatch
end

Redmine::Plugin.register :issue_customers do
  name 'Issue Customers plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

	project_module :supports do
		permission :manage_supports, :supports => [:new, :create]
	end

	project_module :enquetes do
		permission :manage_enquetes, :enquetes => [:index]
	end

	menu :project_menu, :supports, { :controller => 'supports', :action => 'new'}, :param => :project_id, :caption => "サポート"
	menu :project_menu, :enquetes, { :controller => 'enquetes', :action => 'index'}, :param => :project_id, :caption => "アンケート"

end
