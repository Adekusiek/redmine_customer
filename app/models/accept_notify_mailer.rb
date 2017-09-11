class AcceptNotifyMailer < Mailer
  def notify
    mail(to: 'kawahara0114france@gmail.com', subject: 'Welcome to My Awesome Site')
  end
end
