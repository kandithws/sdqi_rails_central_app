class NotificationMailer < ApplicationMailer
  default from: "no-reply@tollgateapp.com"

  def notify_new_record(user, record)
    @user = user
    @record = record
    mail(to: @user.email, subject: 'New toll gate fee is charged')
  end

  def notify_new_bill(user, bill)
    @user = user
    @bill = bill
    mail(to: @user.email, subject: 'New bill has been generated')
  end

  # def notify_new_bill_fails(user)
  #
  # end

  def notify_payment_confirm(user, bill)

  end

end
