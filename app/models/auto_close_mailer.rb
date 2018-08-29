class AutoCloseMailer < Mailer

  def new_status_warning(issue)
    @issue = issue
      mail(to: issue.author.email_address.address, subject: "REDMINE SYSTEM WARNING")

  end

  def close_confirmation(issue, customer)
    @issue = issue
    @customer = customer
    mail(to: customer.email, cc: issue.author.email_address.address, \
      bcc: 'hiroyasu.takase@ipg-automotive.com', \
      subject: "CarMaker Close Confirmation [#{issue.subject} ##{issue.id}]")
  end
end
