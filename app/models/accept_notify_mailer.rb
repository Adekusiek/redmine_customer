class AcceptNotifyMailer < Mailer
  default from: "carmaker-service-jp@ipg-automotive.com"

  def notify_with_license(subject, customer)
#    mail(to: 'kawahara0114@gmail.com', subject: "#{issue.subject}: 受領のお知らせ")
    @customer = customer

    mail(to: 'keisuke.kawahara@ipg-automotive.com', subject: "#{subject}: 受領のお知らせ テスト")
  end

  def notify_without_license(subject, customer)
    @customer = customer
    mail(to: 'keisuke.kawahara@ipg-automotive.com', subject: "#{subject}: 受領のお知らせ　テスト")
  end

end
