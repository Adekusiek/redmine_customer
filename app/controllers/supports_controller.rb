class SupportsController < ApplicationController
  unloadable
	before_filter :find_project, only: [:new,  :create]

  def new
    @company_codes = CompanyCode.all
    @company_code = CompanyCode.new

    # when comming from telephone process page
    @email = params[:email] if params[:email]
    @license = params[:license_num] if params[:license_num]

  end

  def create

    customer = Customer.find_by(email: params[:session][:email])

# if no customer is attached to the email, create new customer and customer_enquete to save the date of last reply and preference of receiving mail
    unless customer
      customer = Customer.new(email: params[:session][:email])
      customer.build_customer_enquete
      customer.save
    end

# give cs number
    subject_header = "CS" + Date.today.year.to_s + "JP" + @project.get_csnum

# search company code from email
    domain = params[:session][:email].split("@")[1]
    company_code = CompanyCode.find_by(domain: domain) ? CompanyCode.find_by(domain: domain).code : "XXX"

    issue = Issue.create({
                project_id: @project,
                subject: subject_header + "(" + company_code + ")",
                description: params[:session][:description],
                assigned_to_id: User.current.id,
                tracker_id: 3,
                author_id: User.current.id,
                start_date: Date.today
      })

# check license status
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
    if params[:session][:send_flag] == "0"
      company_code == "XXX" ?  subject = subject_header : subject = subject_header + "(" + company_code + ")"
      if params[:session][:license_num].blank?
        AcceptNotifyMailer.notify_without_license(subject, customer).deliver_later
      else
        AcceptNotifyMailer.notify_with_license(subject, customer).deliver_later
      end
      flash[:notice] = "メールが送信されました"
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

  def skip_enquete
    issue_customer = IssueCustomer.find_by(issue_id: params[:id])
    enquete = Enquete.new({
      sent_date: Date.new(2016, 1, 1),
      customer_id: issue_customer.customer_id,
      issue_id: issue_customer.issue_id,
      project_id: issue_customer.issue.project.id,
      customer_enquete_id: issue_customer.customer.customer_enquete.id
      })

    if enquete.save!
      flash[:notice] = "このチケットのアンケート送信は行われません"
    else
      flash[:alert] = "アンケート送信スキップの設定に失敗しました"
    end

    redirect_to :back
  end

  def change_auto_close_flag
    issue = Issue.find(params[:id])
    if issue.auto_close_flag
       issue.update(auto_close_flag: false)
       flash[:notice] = "自動クローズ機能オフ"
    else
       issue.update(auto_close_flag: true)
       flash[:notice] = "自動クローズ機能オン"
    end

    redirect_to :back
  end

  private
  def find_project
		@project = Project.find(params[:project_id])
	rescue ActiveRecord::RecordNotFound
		render_404
	end

end
