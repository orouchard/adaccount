class LineItem < ApplicationRecord
  before_save :set_amount
  
  belongs_to :invoice
  belongs_to :product
  
  def set_amount
    self.amount = price * factor * nbr
  end
end
