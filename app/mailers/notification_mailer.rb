class NotificationMailer < ApplicationMailer
  default from: 'notifications@yoyaku.com'
 
  def notification(result)
    @result = result
    addresses = User.all.map{|user| user.mail}
    mail(to: addresses, subject: '[自動送信] 施設に空きあり')
  end
end
