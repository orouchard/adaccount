json.extract! account, :id, :account_number, :title, :increases, :description, :group, :subgroup, :statement, :active, :created_at, :updated_at
json.url account_url(account, format: :json)
