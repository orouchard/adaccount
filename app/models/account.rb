class Account < ApplicationRecord
	has_many :entries
	has_many :month_sums
end
