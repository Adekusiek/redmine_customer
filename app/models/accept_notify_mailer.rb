class AcceptNotifyMailer < Mailer
  default from: "from@example.com"

  def notify_with_license(issue_customer)
#    mail(to: 'kawahara0114@gmail.com', subject: "#{issue.subject}: 受領のお知らせ")

    mail(to: 'kawahara0114@gmail.com', subject: "#{issue.subject}: 受領のお知らせ")
  end

  def notify_without_license(issue)
    mail(to: 'kawahara0114@gmail.com', subject: "#{issue.subject}: 受領のお知らせ")
  end

end
