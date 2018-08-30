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

# if no customer is attached to the email, create new customer to save the date of last reply and preference of receiving mail
    customer = Customer.find_or_create_by(email: params[:session][:email])

# give cs number
    subject_header = "CS" + Date.today.year.to_s + "JP" + @project.get_csnum

# search company code from email
    domain = params[:session][:email].split("@")[1]
    company_code = CompanyCode.find_by(domain: domain) ? CompanyCode.find_by(domain: domain).code : "XXX"


    # check license status
    license_id = if params[:session][:license_num]
      license = License.find_by(license_num: params[:session][:license_num])
      license ? license.id : 0
    else
      0
    end

    issue = Issue.create({
                project_id: @project,
                subject: subject_header + "(" + company_code + ")",
                description: params[:session][:description],
                assigned_to_id: User.current.id,
                tracker_id: 3,
                author_id: User.current.id,
                start_date: Date.today,
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

    issue = Issue.find(params[:issue_id])

    customer = Customer.where(email: params[:session][:email]).first_or_create
    issue.customer_id = customer.id

    license = License.find_by(license_num: params[:session][:license_num])
    issue.license_id = license.id if license

    flash[:notice] = "チケット更新失敗" unless issue.save

    redirect_to issue_path(issue)

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
    issue = Issue.find(params[:id])
    enquete = Enquete.new({
      sent_date: Date.new(2016, 1, 1),
      customer_id: issue.customer_id,
      issue_id: issue.id,
      project_id: issue.project.id,
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
