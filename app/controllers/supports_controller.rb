class SupportsController < ApplicationController
  unloadable
	before_filter :find_project, only: [:new, :create]

  def new
    @company_codes = CompanyCode.all
    @company_code = CompanyCode.new
  end

  def create

    customer = Customer.find_by(email: params[:session][:email])

    unless customer
      customer = Customer.new(email: params[:session][:email])
      customer.build_customer_enquete
      customer.save
    end


    issue_num = @project.issues.count + 1

    if issue_num < 10
      issue_num = "00" + issue_num.to_s
    elsif issue_num < 100
      issue_num = "0" + issue_num.to_s
    else
      issue_num = issue_num.to_s
    end
    subject_header = "CS" + Date.today.year.to_s + "JP" + issue_num

    domain = params[:session][:email].split("@")[1]
    company_code = "XXX"
    company_code = CompanyCode.find_by(domain: domain).code if CompanyCode.find_by(domain: domain)

    issue = Issue.create({
                project_id: @project,
                subject: subject_header + "(" + company_code + ")",
                # Tracker is compulsory
                # Need to change later here
                assigned_to_id: User.current.id,
                tracker_id: 3,
                author_id: User.current.id,
                start_date: Date.today
      })

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

# prepare called value
    if params[:session][:send_flag] == 0
      company_code == "XXX" ?  subject = subject_header : subject = subject_header + "(" + company_code + ")"
      if params[:session][:license_num].blank?
        AcceptNotifyMailer.notify_without_license(subject, customer).deliver_later
      else
        AcceptNotifyMailer.notify_with_license(subject, customer).deliver_later
      end
    end

    redirect_to issue_path(issue)
  end

	def update

    issue_customer = IssueCustomer.find_by(issue_id: params[:issue_id])

    customer = Customer.where(email: params[:session][:email]).first_or_create
    issue_customer.customer_id = customer.id

    license = License.find_by(license_num: params[:session][:license_num])
    issue_customer.license_id = license.id if license

    issue_customer.save
    redirect_to issue_path(issue_customer.issue)

	end

  def category_import
    @project = Project.find(params[:id])
    import_project = Project.find_by(name: params[:session][:name])
    import_project.issue_categories.each do |category|
      IssueCategory.create(project_id: @project.id, name: category.name, assigned_to_id: category.assigned_to_id)
    end

    redirect_to project_supports_new_path(@project)
  end

  private
  def find_project
		@project = Project.find(params[:project_id])
	rescue ActiveRecord::RecordNotFound
		render_404
	end

end
