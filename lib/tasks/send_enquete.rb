# This script supp
module SendEnquete
  def search
    issues = Issue.where(updated_on: Time.months_ago(1)..Time.today)
    issue_sent_enquetes = Enquete.where(sent_date: Date.last_year..Date.today).issue
    issues.each do |issue|
      if issue.issue_status.is_closed == 1
        unless issue_sent_enquetes.include?(issue)
          self.send(issue)
        end
      end
    end
  end

  def send(issue)
    issue_customer = IssueCustomer.find_by(issue_id: issue.id).includes(:customer)
    if issue_customer.customer.customer_enquete.accept_flag == 1 && issue_customer.customer.customer_enquete.last_reply_date <  6.months_ago
      #Mailer
      EnqueteMailer.enquete_send_mailer(issue.subject, issue_customer.customer).deliver_later

      Enquete.create({
        sent_date: Date.today,
        customer_id: issue_customer.customer.id,
        project_id: issue.project.id,
        issue_id: issue.id,
        recieved_flag: 0
        })

    end

  end
end
