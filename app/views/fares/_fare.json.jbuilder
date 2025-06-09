json.extract! fare, :id, :departure, :arrival, :distance, :fare_small, :fare_medium, :fare_large, :created_at, :updated_at
json.url fare_url(fare, format: :json)
