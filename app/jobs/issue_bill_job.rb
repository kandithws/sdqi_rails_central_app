class IssueBillJob < ActiveJob::Base
  def perform
    logger.info("Running Issue Bill Job")
    @users = User.where(admin: false)
    fail_ids = []
    @users.each do |user|
      unissued_records = TollFeeRecord.where(car: user.cars, bill_id:nil) # get all records that not yet issued
      new_bill = Bill.create({user: user, toll_fee_records: unissued_records, payment_deadline: 2.weeks.from_now})
      if new_bill
        NotificationMailer.notify_new_bill(user,new_bill).deliver
      else
        fail_ids << user.id
      end
    end

    if fail_ids.count > 0
      # TODO -- notify admin
      logger.error('[ISSUEBILLJOB] FAILS TO Create Bill for following User IDs:' + fail_ids.to_s )
    else
      logger.info('[ISSUEBILLJOB] Create Bill Success for ALL USER' )
    end
  end
end