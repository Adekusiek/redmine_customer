class AcceptNotifyMailer < Mailer
  default from: "carmaker-service-jp@ipg-automotive.com"

  def notify_with_license(subject, customer)
    @customer = customer

    mail(to: @customer.email, bcc: 'carmaker-service-jp@ipg-automotive.com', subject: "CarMaker問い合わせ受領のお知らせ")
  end

  def notify_without_license(subject, customer)
    @customer = customer
    mail(to: @customer.email, bcc: 'carmaker-service-jp@ipg-automotive.com', subject: "CarMaker問い合わせ受領のお知らせ")
  end

end
