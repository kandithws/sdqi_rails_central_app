json.extract! car, :id, :license_plate_number, :brand, :car_model_name, :car_model_year, :color, :user_id, :created_at, :updated_at
json.url car_url(car, format: :json)
