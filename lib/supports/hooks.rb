module Supports
	class Hooks < Redmine::Hook::ViewListener
		render_on :view_issues_show_description_bottom,
							:partial => 'hooks/supports/issue_customers'
	end
end
