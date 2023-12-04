class WizardController < ApplicationController
	before_action :enrollment_wiz, only: %i[ enrollment ] # validates the  form on the wizard

	def enrollment
		# 1 create the invoice from user
		@invoice = @user.invoices.create!(date_issue: @invoice_date, date_due: @due_date, description: @description, currency: @currency)
			# '-> Creates the "Resident Line Item" of the invoice
			@first_line = @invoice.line_items.create!(product: @line_item, price: @price, nbr: 1, factor: 1, amount: @price)
			# '-> If the uniform option is selected from the form
			if params[:wizz][:uniform] == "yes"
				set_uniform_price
				unless @uniform_price.nil?
					@last_line = @invoice.line_items.create!(product: @uniform, price: @uniform_price.amount, nbr: 1, factor: @vat, amount: @uniform_price.amount*@vat)
				end
			end
		# Updates the invoice's total
		@invoice.update_total

		create_initial_journal(@invoice) # Create the initial journal entry for the invoice
			create_journal_entry(@initial_journal, @invoice.total, 7, "debit") #  '-> Creates the "Resident Line Item" of the journal
			create_journal_entry(@initial_journal, @first_line.price, 30, "credit") #  '-> Creates the "Unearned Revenue" of the journal
			create_journal_entry(@initial_journal, @last_line.price*0.08, 31, "credit") #  '-> Creates the "Sales Tax Payable" of the journal
			create_journal_entry(@initial_journal, @last_line.price, 39, "credit") #	'-> Creates the "Sales" of the journal
			@initial_journal.balanced? # check @initial_journal is balanced

		redirect_to @invoice

		# Create the invoice payment terms
		invoice_payment
		@invoice.update description: @description + " // Payment is paid #{@the_payment}."
	end

	def destroy
		@invoice = Invoice.find(params[:invoice_id])
		@invoice.journals.each do |j|
			j.destroy
		end
		@invoice.destroy
		redirect_to @invoice.user
	end

private

	def enrollment_wiz
	  if params["wizz"]["line_item"].empty? || params["wizz"]["line_item_amount"].empty? || params["wizz"]["uniform"].empty?  || params["wizz"]["invoice_date"].empty? || params["wizz"]["part_time"].empty? || params["wizz"]["school_period"].empty? || params["wizz"]["dates"].size == 1
	  	redirect_to @user, notice: "The Wizard Form must be fully completed"
	  else
		@dates = []
			params["wizz"]["dates"].drop(1).each do |d|
				@dates << Date.parse(d)
			end
		@user = User.find(params[:user_id])
		@line_item = Product.find(params[:wizz][:line_item])
		@period = Period.find(params[:wizz][:school_period])
		@due_date = params["wizz"]["due_date"].empty? ? @period.due_date : params[:wizz][:due_date]
		@invoice_date, @currency, @price = params[:wizz][:invoice_date], params[:wizz][:currency], params[:wizz][:line_item_amount]
		@period = Period.find(params[:wizz][:school_period])
		@start_date = params[:wizz][:start_date].empty? ? @period.date_from : Date.parse(params[:wizz][:start_date])
		@description = "Tuition for the period #{@start_date.strftime("%B %Y")} to #{@dates.last.strftime("%B %Y")}."
		end
	end


	def set_uniform_price
		@uniform = Product.find_by(name: "Start Uniform Set")
		@uniform_price = @uniform.prices.where("date_from <= :date and date_to >= :date", {date: @invoice_date}).where(active: true).first
		@vat = 1.08
	end

	def create_initial_journal(invoice)
		@initial_journal = invoice.journals.new
		@initial_journal.date = invoice.date_issue
		@initial_journal.description = "Invoice ##{invoice.id} for #{invoice.user.name} for the period #{@start_date.strftime("%B %Y")} to #{@dates.last.strftime("%B %Y")}."
		@initial_journal.currency = invoice.currency
		@initial_journal.trans_nat = "transactional"
		@initial_journal.balanced = true
		# Save the journal entry
		@initial_journal.save
	end

	def invoice_payment
		@rand_pay = rand(1..100)
		trans_nat = "financial"

		case @rand_pay
		when 1..15
			# payment is made within 45 days of due date
			@the_payment = "within 45 days of due date"
			date = @invoice.date_due + rand(1..45).days
			description = "Payment received from invoice ##{@invoice.id} on #{date.strftime("%d %B %Y")}."
			journal = @invoice.journals.create(date: date, description: description, trans_nat: trans_nat, currency: @invoice.currency, balanced: true)
			create_journal_entry(journal, @invoice.total, 1, "debit")
			create_journal_entry(journal, @invoice.total, 7, "credit")

		when 16..24
			#payment is made within 45 days after school starts
			@the_payment = "within 45 days after school starts"
			date = @start_date + rand(1..45).days
			description = "Payment received from invoice ##{@invoice.id} on #{date.strftime("%d %B %Y")}."
			journal = @invoice.journals.create(date: date, description: description, trans_nat: trans_nat, currency: @invoice.currency, balanced: true)
			create_journal_entry(journal, @invoice.total, 1, "debit")
			create_journal_entry(journal, @invoice.total, 7, "credit")

		when 25..34
			# payment is made in 3 installments: 40% at the beginning of the period, 30% after 33 days, 30% after 63 days
			@the_payment = "in 3 installments: 40% at the beginning of the period, 30% after 33 days, 30% after 63 days"
			dates = [@start_date, @start_date + 33.days, @start_date + 63.days]
			descriptions = ["1 of 3, 40% payment received from invoice ##{@invoice.id} on #{dates[0].strftime("%d %B %Y")}.", "2 of 3, 30% payment received from invoice ##{@invoice.id} on #{dates[1].strftime("%d %B %Y")}.", "3 of 3, 30% payment received from invoice ##{@invoice.id} on #{dates[2].strftime("%d %B %Y")}."]
			ratio = [0.4, 0.3, 0.3]
			dates.each_with_index do |d, i|
				journal = @invoice.journals.create(date: d, description: descriptions[i], trans_nat: trans_nat, currency: @invoice.currency, balanced: true)
				create_journal_entry(journal, @invoice.total * ratio[i], 1, "debit")
				create_journal_entry(journal, @invoice.total * ratio[i], 7, "credit")
			end

		when 35..37
			# payment is made in 4 installments: 30% at the beginning of the period, 25% after 33 days, 25% after 63 days, 20% after 93 days
			@the_payment = "in 4 installments: 30% at the beginning of the period, 25% after 33 days, 25% after 63 days, 20% after 93 days"
			dates = [@start_date, @start_date + 33.days, @start_date + 63.days, @start_date + 93.days]
			descriptions = ["1 of 4, 30% payment received from invoice ##{@invoice.id} on #{dates[0].strftime("%d %B %Y")}.", "2 of 4, 25% payment received from invoice ##{@invoice.id} on #{dates[1].strftime("%d %B %Y")}.", "3 of 4, 25% payment received from invoice ##{@invoice.id} on #{dates[2].strftime("%d %B %Y")}.", "4 of 4, 20% payment received from invoice ##{@invoice.id} on #{dates[3].strftime("%d %B %Y")}."]
			ratio = [0.3, 0.25, 0.25, 0.2]
			dates.each_with_index do |d, i|
				journal = @invoice.journals.create(date: d, description: descriptions[i], trans_nat: trans_nat, currency: @invoice.currency, balanced: true)
				create_journal_entry(journal, @invoice.total * ratio[i], 1, "debit")
				create_journal_entry(journal, @invoice.total * ratio[i], 7, "credit")
			end

		when 38..69
			# payment is made within 30 days before due date
			@the_payment = "within 30 days before due date"
			date = @invoice.date_due - rand(1..30).days
			description = "Payment received from invoice ##{@invoice.id} on #{date.strftime("%d %B %Y")}."
			journal = @invoice.journals.create(date: date, description: description, trans_nat: trans_nat, currency: @invoice.currency, balanced: true)
			create_journal_entry(journal, @invoice.total, 1, "debit")
			create_journal_entry(journal, @invoice.total, 7, "credit")

		when 70..84
			# payment is made between 45 and 31 days before due date
			# discount is 1% of the tuition fee only
			@the_payment = "between 45 and 31 days before due date with a 1% discount"
			date = @invoice.date_due - rand(1..30).days
			description = ["Payment received from invoice ##{@invoice.id} on #{date.strftime("%d %B %Y")}.", "1% discount for advance payment between 45 and 31 days from invoice ##{@invoice.id} on #{date.strftime("%d %B %Y")}."]
			amount_paid =  @invoice.total - @first_line.price * 0.01
			discount = @first_line.price * 0.01
			journal = @invoice.journals.create(date: date, description: description[0], trans_nat: trans_nat, currency: @invoice.currency, balanced: true)
			create_journal_entry(journal, amount_paid, 1, "debit")
			create_journal_entry(journal, amount_paid, 7, "credit")
			journal = @invoice.journals.create(date: date, description: description[1], trans_nat: "transactional", currency: @invoice.currency, balanced: true)
			create_journal_entry(journal, discount, 40, "debit")
			create_journal_entry(journal, discount, 7, "credit")

		when 85..100
			# payment is made between 60 and 46 days before due date
			# discount is 2% of the tuition fee only
			@the_payment = "between 60 and 46 days before due date with a 2% discount"
			date = @invoice.date_due - rand(46..60).days
			description = ["Payment received from invoice ##{@invoice.id} on #{date.strftime("%d %B %Y")}.", "2% discount for advance payment between 60 and 46 days from invoice ##{@invoice.id} on #{date.strftime("%d %B %Y")}."]
			amount_paid =  @invoice.total - @first_line.price * 0.02
			discount = @first_line.price * 0.02
			journal = @invoice.journals.create(date: date, description: description[0], trans_nat: trans_nat, currency: @invoice.currency, balanced: true)
			create_journal_entry(journal, amount_paid, 1, "debit")
			create_journal_entry(journal, amount_paid, 7, "credit")
			journal = @invoice.journals.create(date: date, description: description[1], trans_nat: "transcation", currency: @invoice.currency, balanced: true)
			create_journal_entry(journal, discount, 40, "debit")
			create_journal_entry(journal, discount, 7, "credit")
		end
	end

end
