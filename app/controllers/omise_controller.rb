class OmiseController < ApplicationController
  protect_from_forgery with: :null_session

  def omise_callback
    if (params[:object] == "event") && (params[:key] == "charge.complete")
      @bill = Bill.find_by_omise_charge_id(params[:data][:id])
      if @bill && (!@bill.payment_confirm)
        @bill.payment_method = "barcode"
        @bill.payment_confirm = true
        if @bill.save
          NotificationMailer.notify_payment_confirm_accept_omise(@user, @bill).deliver
          respond_to do |format|
            format.json { render json: '{status: success}', status: :created}
          end
        end
      end
    end

    respond_to do |format|
      format.json { render json: '{status: error}', status: :not_found}
    end
  end
end
