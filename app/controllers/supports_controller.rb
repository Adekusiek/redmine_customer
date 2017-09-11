class SupportsController < ApplicationController
  unloadable
	before_filter :find_project, only: [:new, :create]

  def new
    @company_codes = CompanyCode.all
    @company_code = CompanyCode.new
  end

  def create

    customer = Customer.where(email: params[:session][:email]).first_or_create

    issue_num = @project.issues.count + 1

    if issue_num < 10
      issue_num = "00" + issue_num.to_s
    elsif issue_num < 100
      issue_num = "0" + issue_num.to_s
    else
      issue_num = issue_num.to_s
    end

    domain = params[:session][:email].split("@")[1]

    company_code = "XXX"
    company_code = CompanyCode.find_by(domain: domain).code if CompanyCode.find_by(domain: domain)

    issue = Issue.create({
                project_id: @project,
                subject: "CS" + Date.today.year.to_s + "JP" + issue_num + "(" + company_code + ")",
                # Tracker is compulsory
                # Need to change later here
                assigned_to_id: User.current.id,
                tracker_id: 3,
                author_id: User.current.id,
                start_date: Date.today
      })
    issue.save

    license_id = 0
    if params[:session][:license_num]
      license = License.find_by(license_num: params[:session][:license_num])
      license_id = license.id  if license
    end

    IssueCustomer.create({
                issue_id: issue.id,
                customer_id: customer.id,
                license_id: license_id
      })

    AcceptNotifyMailer.notify.deliver_now
    redirect_to issue_path(issue)
  end

	def update

    issue_customer = IssueCustomer.find_by(issue_id: params[:issue_id])

    customer = Customer.where(email: params[:session][:email]).first_or_create
    issue_customer.customer_id = customer.id

    if params[:session][:license_num]
      license = License.find_by(license_num: params[:session][:license_num])
      issue_customer.license_id = license.id if license
    end

    issue_customer.save
    redirect_to issue_path(issue_customer.issue)

	end

  private
  def find_project
		@project = Project.find(params[:project_id])
	rescue ActiveRecord::RecordNotFound
		render_404
	end

end
