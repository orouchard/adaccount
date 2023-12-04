class Journal < ApplicationRecord
	has_many :entries, dependent: :destroy
	
	has_many :invoice_journal_link, dependent: :destroy
	has_many :invoices, through: :invoice_journal_link
end
