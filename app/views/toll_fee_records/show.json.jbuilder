json.extract! toll_fee_record, :id, :license_plate_number, :brand, :car_model_name, :car_model_year, :color, :user_id, :created_at, :updated_at
json.url car_url(toll_fee_record, format: :json)