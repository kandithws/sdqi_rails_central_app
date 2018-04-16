class BillsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_bill, only: [:show, :update_slip, :update_barcode,
                                  :unconfirmed_show, :unconfirmed_update, :export_pdf]

  def index
    @bills = current_user.bills.order("created_at DESC")
  end

  # Presereved only for admin to create Bills Manually
  def create
    # get all member in the system
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
        logger.error('FAILS TO Create Bill for following User IDs:' + fail_ids.to_s )
    end

    flash.now[:success] = "Bill Generated"
    respond_to do |format|
      format.html{ redirect_to dashboard_path }
    end
  end

  def show
    if @bill.payment_confirm
      flash.now[:success] = "This bill has already been paid"
    else
      if @bill.exceed_deadline?
        flash.now[:error] = "ALERT! Already pass the payment deadline, you will be charged"
      else
        flash.now[:alert] = "Warning, you haven't paid this bill yet! or Admin has not confirmed the payment"
      end
    end
  end

  def export_pdf
    render pdf: "Exported_Bill", template: "bills/export_pdf.html.erb", page_size: "A4", encoding: "UTF-8"
  end

  # Must be at least 20 Baht To use this feature
  def update_barcode

    if !@bill.payment_confirm
        if @bill.total_amount >= 20.0
          @bill.payment_method = "barcode"
          st = @bill.update_attributes_omise_barcode
          if st && @bill.save
            respond_to do |format|
              flash[:success] = "Your barcode is successfully generated, please check your email"
              format.html{ redirect_to bill_path(@bill)}
            end
          else
            respond_to do |format|
              flash.now[:error] = "Cannot Update payment Barcode, or the previous barcode is not expired"
              format.html{ redirect_to bill_path(@bill)}
            end
          end
        else
          respond_to do |format|
            flash.now[:error] = "Cannot Create Barcode, total amount must be at least 20 Baht"
            format.html{ redirect_to bill_path(@bill)}
          end
        end


    else
        respond_to do |format|
          flash.now[:error] = "This payment has already confirm!"
          format.html{ redirect_to root_path }
        end
    end
  end

  # For user to manually update slip
  def update_slip
    if !@bill.payment_confirm
      @bill.assign_attributes(params.require(:bill).permit(:payment_evidence))
      @bill.payment_method = "manual"

      if @bill.save
        respond_to do |format|
          flash[:success] = "Successfully Upload Payment Slip, please wait for admin to verify"
          format.html{ redirect_to bill_path(@bill), success: "Successfully Upload Payment Slip, please wait for admin to verify" }
        end
      else
        respond_to do |format|
          flash.now[:error] = "Cannot Upload Payment Slip"
          format.html{ redirect_to bill_path(@bill)}
        end
      end
    else
      respond_to do |format|
        flash.now[:error] = "This payment has already confirm!"
        format.html{ redirect_to root_path }
      end
    end
  end

  # For admins
  def unconfirmed_index
    @bills = Bill.where(payment_method: "manual", payment_confirm: false).where.not(payment_evidence_file_name: [nil, ""])
  end

  def unconfirmed_show
  end

  def unconfirmed_update
    if params[:is_confirmed]
      @bill.payment_confirm = true
      if @bill.save()
        # send email to user (accept)
        NotificationMailer.notify_payment_confirm_accept(@bill.user, @bill).deliver
      else
        flash.now[:error] = "Cannot Persisted to Database"
      end
    else
      @bill.payment_confirm = false
      @bill.payment_evidence.clear
      @bill.payment_method = nil
      if @bill.save()
        # send email to user (reject)
        NotificationMailer.notify_payment_confirm_reject(@bill.user, @bill).deliver
      else
        flash.now[:error] = "Cannot Persisted to Database"
      end
    end
    redirect_to unconfirmed_bills_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bill
    @bill = Bill.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def bill_params
  #   # params.require(:bill).permit(:payment_evidence)
  # end

end
