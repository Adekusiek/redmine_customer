class EnqueteMailer < Mailer

  def enquete_send_mailer(issue, customer)
    @customer = customer
    mail(to: customer.email, cc: "kaori.homma@ipg-automotive.com", bcc: "keisuke.kawahara@ipg-automotive.com", \
       subject: "顧客満足度調査(サポート編)へのご協力のお願い CarMaker Support Enquete [#{issue.subject} ##{issue.id}]")
  end


end
