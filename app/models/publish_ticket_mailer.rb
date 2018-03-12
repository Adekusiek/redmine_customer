class PublishTicketMailer < Mailer

  def send_mailer(issue)
    @issue = issue
    mail(to: "carmaker-service-jp@ipg-automotive.com",  subject: "#{issue.subject} : チケット登録の完了")
  end

end
