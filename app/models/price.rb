class Price < ApplicationRecord
  belongs_to :product
  validates_presence_of [:date_from, :date_to, :amount, :currency]
end
