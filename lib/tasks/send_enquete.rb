
class SendEnquete
  def self.search
    issues = Issue.where(updated_on: 1.month.ago..Time.now)
#    issue_sent_enquetes = Enquete.where(sent_date: Date.today.prev_year..Date.today)


# N+1 how to read enquete correctly?
    issues.each do |issue|
      if issue.done_ratio == 100
        unless Enquete.find_by(issue_id: issue.id)
          send(issue)
        end
      end
    end
  end

  def self.send(issue)
    issue_customer = IssueCustomer.find_by(issue_id: issue.id)
    return if !issue_customer || !issue_customer.customer 
    if issue_customer.customer.customer_enquete.accept_flag == true && issue_customer.customer.customer_enquete.last_reply_date <  Date.today.months_ago(6)
      #Mailer
      EnqueteMailer.enquete_send_mailer(issue.subject, issue_customer.customer).deliver_later

      Enquete.create({
        customer_id: issue_customer.customer.id,
        project_id: issue.project.id,
        issue_id: issue.id,
        customer_enquete_id: issue_customer.customer.customer_enquete.id
        })

    end

  end
end

SendEnquete.search
