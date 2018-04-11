class TollFeeRecordsController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :authenticate_tollbooth, only: [:create]
  # List all user_dashboard toll fee records
  def index
  end

# https://stackoverflow.com/questions/23153099/rails-get-multipart-form-data-post-request-parameters-with-same-name/23215937
  def create
    if @toll_booth
      # TODO
      respond_to do |format|
        format.json{ render status: unauthorized}
      end
    else
      respond_to do |format|
        format.json{ render status: unauthorized}
      end
    end
  end

  private
    def authenticate_tollbooth
      authenticate_or_request_with_http_token do |token, options|
        @toll_booth = TollBooth.where(api_key: token).first
      end
    end

    def toll_fee_record_params
      params.req
    end

end
