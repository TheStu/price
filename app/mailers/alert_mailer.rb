class AlertMailer < ActionMailer::Base
  default from: "Camping Price Search <admin@campingpricesearch.com>"
  helper ApplicationHelper

  def price_alert(user, alert, buy_link, found_price)
    @user = user
    @alert = alert
    @buy_link = buy_link
    @found_price = found_price
    mail(:to => user.email, :subject => "Price Alert Notification")
  end
end
