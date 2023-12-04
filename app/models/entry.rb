class Entry < ApplicationRecord
  belongs_to :journal
  belongs_to :account
  
  scope :month_entries, -> (account, start_date, end_date) { select(:amount, :flow, :journal_id).joins(:journal).where("entries.account_id = ? and journals.active = ? and journals.date between ? and ?", account.id, true, start_date, end_date) }
end
