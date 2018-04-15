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

  # Manual upload only
  def notify_payment_confirm_accept(user, bill)
    @user = user
    @bill = bill
    mail(to: @user.email, subject: 'Payment for bill #' + @bill.id.to_s + ' is accepted' )
  end

  def notify_payment_confirm_reject(user, bill)
    @user = user
    @bill = bill
    mail(to: @user.email, subject: 'Payment for bill #' + @bill.id.to_s + ' is rejected' )
  end

end
