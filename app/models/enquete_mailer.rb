class EnqueteMailer < Mailer
  default from: "from@example.com"

  def enquete_send_mailer(subject, customer)
#    mail(to: 'kawahara0114@gmail.com', subject: "#{issue.subject}: 受領のお知らせ")
    @customer = customer

    mail(to: 'kawahara0114@gmail.com', subject: "#{subject} : 顧客満足度調査(サポート編)へのご協力のお願い")
  end


end
