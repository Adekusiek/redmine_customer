class EnqueteMailer < Mailer

  def enquete_send_mailer(subject, customer)
    @customer = customer

    mail(to: @customer.email, cc: "kaori.homma@ipg-automotive.com", bcc: "carmaker-service-jp@ipg-automotive.com", subject: "#{subject} : 顧客満足度調査(サポート編)へのご協力のお願い")
  end


end
