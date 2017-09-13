require 'redmine'
require_dependency 'supports/hooks'

Rails.configuration.to_prepare do
	require_dependency 'issues_controller'
	# unless IssuesController.included_modules.include? Supports::IssuesControllerPatch
	# 	IssuesController.send(:include, Supports::IssuesControllerPatch)
	# end
	IssuesController.send :prepend, Supports::IssuesControllerPatch

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
	menu :project_menu, :supports, { :controller => 'supports', :action => 'new'}, :param => :project_id

end
