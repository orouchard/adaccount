class Param < ApplicationRecord
	
	scope :first_day, -> { Date.parse(where(group: "dates", label: "Start Date").pick(:value)) }
	scope :months_dur, -> { where(group: "dates", label: "Months").pick(:value).to_i }
	scope :last_day, -> { first_day + months_dur.months - 1.day }
	
end
