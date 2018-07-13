class AutoCloseMailer < Mailer

  def new_status_warning(issue)
      mail(to: issue.author.email_address.address, subject: "REDMINE SYSTEM WARNING")
  end

  def close_confirmation(issue, customer)

    mail(to: customer.email, cc: issue.author.email_address.address, \
      subject: "CarMaker Close Confirmation [#{issue.subject} ##{issue.id}]")
  end
end
