
module SendEnquete
  def self.search
    issues = Issue.where(updated_on: 1.month.ago..Time.now)
    # search status id of closed issue
    issuestatus = IssueStatus.where(is_closed: 1)
    closed_ids = []
    issuestatus.each do |status|
      closed_ids << status.id
    end

# N+1 how to read enquete correctly?
    issues.each do |issue|
      # skip if the project is not Customer support children or older than 2017
      next unless issue.project.parent_id == 3 && issue.project.id >= 18
      if closed_ids.include?(issue.status_id)
        unless Enquete.find_by(issue_id: issue.id)
          send(issue)
        end
      end
    end
  end

  def self.send(issue)
    issue_customer = IssueCustomer.find_by(issue_id: issue.id)
    return if !issue_customer || !issue_customer.customer
    # Check if customer accept receive the enquete mail and if replied within 6 months
    if issue_customer.customer.customer_enquete.accept_flag == true && issue_customer.customer.customer_enquete.last_reply_date <  Date.today - 3.months
      # Check if enquete mail is sent within 1 month for another ticket
      latest_enquete = Enquete.where(customer_id: issue_customer.customer.id).order(sent_date: "DESC").first
      if latest_enquete.nil? || latest_enquete.sent_date < Date.today - 1.months

        Enquete.create({
          sent_date: Date.today,
          customer_id: issue_customer.customer.id,
          project_id: issue.project.id,
          issue_id: issue.id,
          customer_enquete_id: issue_customer.customer.customer_enquete.id
          })
        #Mailer
        EnqueteMailer.enquete_send_mailer(issue, issue_customer.customer).deliver

        return
      end
    end
    # if enquete mail is not delivered, create dummy enquete
    Enquete.create({
      sent_date: "2016-01-01",
      customer_id: issue_customer.customer.id,
      project_id: issue.project.id,
      issue_id: issue.id,
      customer_enquete_id: issue_customer.customer.customer_enquete.id
      })
    puts "skip #{issue.subject}"
  end
end

SendEnquete.search
