class Product < ApplicationRecord
	acts_as_list
	validates_presence_of [:name, :description]
	has_many :prices, dependent: :destroy
    has_many :line_items, dependent: :destroy
	
	scope :active, -> { where(active: true) }
end
