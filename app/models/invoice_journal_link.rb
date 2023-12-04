class InvoiceJournalLink < ApplicationRecord
  belongs_to :invoice
  belongs_to :journal
end
