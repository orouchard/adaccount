class Invoice < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy

  has_many :invoice_journal_link, dependent: :destroy
  has_many :journals, through: :invoice_journal_link, dependent: :destroy

  def update_total
    self.update(total: self.line_items.sum(:amount))
  end

end
