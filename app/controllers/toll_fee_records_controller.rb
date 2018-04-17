# require 'multipart_parser/reader'

class TollFeeRecordsController < ApplicationController
  protect_from_forgery with: :null_session # disable CRSF protection for api controller
  before_action :authenticate_user!, except: [:create, :create_with_image]
  before_action :authenticate_tollbooth, only: [:create, :create_with_image]

  # List all user_dashboard toll fee records
  def index
    @toll_fee_records = current_user.toll_fee_records.order("created_at DESC")
  end

  def show
    # Basically authorize resource here
    @toll_fee_record = TollFeeRecord.find_by_id(params[:id])
    unless @toll_fee_record.car.user.id == current_user.id
      flash[:error] = "Unauthorized"
      redirect_to dashboard_path
    end
  end

# https://stackoverflow.com/questions/23153099/rails-get-multipart-form-data-post-request-parameters-with-same-name/23215937
  def create
    if @toll_booth
      @car = Car.find_by_license_plate_number(params[:license_plate_number])
      if @car
        @toll_fee_record = TollFeeRecord.create({toll_booth: @toll_booth, car:@car, timestamp: DateTime.now})
        if @toll_fee_record
          NotificationMailer.notify_new_record(@car.user, @toll_fee_record).deliver
          respond_to do |format|
            format.json{ render json: '{"status": "success"}',status: :created}
          end
        else
          respond_to do |format|
            format.json{ render json: '{"status": "internal database error"}',status: :internal_server_error}
          end
        end

      else
        # Notfound send alert
        respond_to do |format|
          format.json{ render json: '{"status": "not found"}', status: :unprocessable_entity}
        end
      end
    else
      respond_to do |format|
        format.json{ render json: '{"status": "unauthorized"}', status: :unauthorized}
      end
    end
  end

  def create_with_image
    if @toll_booth
      data = JSON.parse params["json"]
      image = params["image"]
      @car = Car.find_by_license_plate_number(data["license_plate_number"])
      if @car
        @toll_fee_record = TollFeeRecord.create({toll_booth: @toll_booth, car:@car, timestamp: DateTime.parse(data["timestamp"]), image: image})
        if @toll_fee_record
          NotificationMailer.notify_new_record(@car.user, @toll_fee_record).deliver
          respond_to do |format|
            format.any{ render json: '{"status": "success"}',status: :created, content_type: 'application/json'}
          end
        else
          respond_to do |format|
            format.any{ render json: '{"status": "internal database error"}', status: :internal_server_error, content_type: 'application/json'}
          end
        end

      else
        # Notfound send alert
        respond_to do |format|
          format.any{ render json: '{"status": "not found"}', status: :unprocessable_entity, content_type: 'application/json'}
        end
      end
    else
      respond_to do |format|
        format.any{ render json: '{"status": "unauthorized"}', status: :unauthorized, content_type: 'application/json'}
      end
    end
  end

  private
    def authenticate_tollbooth
      authenticate_or_request_with_http_token do |token, options|
        @toll_booth = TollBooth.where(api_key: token).first
        @toll_booth
      end
    end


end
