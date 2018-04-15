require 'multipart_parser/reader'

class TollFeeRecordsController < ApplicationController
  protect_from_forgery with: :null_session # disable CRSF protection for api controller
  before_action :authenticate_user!, except: [:create]
  before_action :authenticate_tollbooth, only: [:create]

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

  # https://stackoverflow.com/questions/22567306/python-requests-file-upload
  # https://github.com/pluralsight/guides/blob/master/published/ruby-ruby-on-rails/handling-file-upload-using-ruby-on-rails-5-api/article.md
  def create_with_image
    # TODO -- Implement This
    if @toll_booth
      mp = parse_multi_params(request)
      data = JSON.decode mp[:json]

    else
      respond_to do |format|
        format.json{ render json: '{"status": "unauthorized"}', status: :unauthorized}
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

  def parse_multi_params(request)
    parts={}

    reader = MultipartParser::Reader.new(MultipartParser::Reader::extract_boundary_value(request.headers['CONTENT_TYPE']))

    reader.on_part do |part|
      pn = part.name.to_sym
      part.on_data do |partial_data|
        if parts[pn].nil?
          parts[pn] = partial_data
        else
          parts[pn] = [parts[pn]] unless parts[pn].kind_of?(Array)
          parts[pn] << partial_data
        end
      end
    end

    reader.write request.raw_post
    reader.ended? or raise Exception, 'truncated multipart message'

    parts
  end

end
