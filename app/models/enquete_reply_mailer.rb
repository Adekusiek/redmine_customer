class EnqueteReplyMailer < Mailer

  def enquete_send_mailer(issue, customer)
    @customer = customer
    mail(to: customer.email, bcc: "keisuke.kawahara@ipg-automotive.com", subject: "#{issue.subject} : 顧客満足度調査への回答御礼")
  end

end
