class EnqueteMailer < Mailer

  def enquete_send_mailer(issue, customer)
    @customer = customer
    mail(to: customer.email, bcc: "hiroyasu.takase@ipg-automotive.com", \
       subject: "顧客満足度調査(サポート編)へのご協力のお願い CarMaker Support Enquete [#{issue.subject} ##{issue.id}]")
  end

  def enquete_reply_mailer(issue, customer)
    @customer = customer
    mail(to: customer.email, bcc: "hiroyasu.takase@ipg-automotive.com", subject: "#{issue.subject} : 顧客満足度調査への回答御礼")
  end
end
