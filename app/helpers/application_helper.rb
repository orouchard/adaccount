module ApplicationHelper

	def odd_bg(i)
		if i.odd?
			'odd_row'
		else
			'even_row'
		end
	end
	
	def active(status)
		status ? "text-bg-success" : "text-bg-warning"
	end
	
	def active_status(status)
		status ? "Active" : "Inactive"
	end
	
	def read_date(date)
		date.strftime("%d/%m/%Y")
	end
	
	def read_date_word(date)
		date.strftime("%d %b %Y")
	end
	
	def render_entries(flow, id)
		if @entry && @entry.id == id
			"entries/edit"
		else
			"journals/#{flow}"
		end
	end
	
	def to_amount(amount, currency)
		if currency == 'vnd'
			number_to_currency(amount, unit: currency.upcase, separator: ",", delimiter: " ", format: "%n %u", precision: 0)
		elsif currency == 'euro'
			number_to_currency(amount, unit: '€', separator: ",", delimiter: " ", format: "%n %u", precision: 2)
		elsif currency == 'usd'
			number_to_currency(amount)
		end
	end

end
