json.extract! price, :id, :product_id, :date_from, :date_to, :amount, :currency, :active, :created_at, :updated_at
json.url price_url(price, format: :json)
