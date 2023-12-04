json.extract! invoice, :id, :user_id, :currency, :date_issue, :date_due, :active, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
