class AcceptNotifyMailer < Mailer
  default from: "from@example.com"

  def notify_with_license(subject, customer)
#    mail(to: 'kawahara0114@gmail.com', subject: "#{issue.subject}: 受領のお知らせ")
    @customer = customer

    mail(to: 'kawahara0114@gmail.com', subject: "#{subject}: 受領のお知らせ")
  end

  def notify_without_license(subject, customer)
    @customer = customer
    mail(to: 'kawahara0114@gmail.com', subject: "#{subject}: 受領のお知らせ")
  end

end
