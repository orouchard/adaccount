json.extract! journal, :id, :date, :description, :currency, :trans_nat, :balanced, :active, :created_at, :updated_at
json.url journal_url(journal, format: :json)
