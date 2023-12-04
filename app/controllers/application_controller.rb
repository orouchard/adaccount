class ApplicationController < ActionController::Base

	# def sum_of_entries
		# (account, start_date, end_date)
		# "hello world"
		# total = 0.to_f
		# Entry.select(:amount, :flow).joins(:journal).where("entries.account_id = ? and journals.active = ? and journals.date between ? and ?", account.id, true, start_date, end_date).each do |e|
		#   if account.increases.downcase == e.flow
		# 	total += e.amount
		#   else
		# 	total -= e.amount
		#   end
		# end
		# total
	 # end

	private

  	def set_months
		@months = Array.new
		@months_dur.times { |i| @months << @d1 + i.months }
  	end

  	# This methods creates a hash of groups and subgroups for the Income Statement
  	def build_is_groups
		@groups = Hash.new
		Account.select(:group).distinct.where(statement: "Income Statement").map(&:group).each do |group|
	  	@groups[group] = []
		end
		@groups.keys.each do |key|
	  	Account.select(:subgroup).distinct.where(group: key).map(&:subgroup).each do |b|
			@groups[key] << b
	  	end
		end
  	end

	def set_trans_nat
	  @trans_nat = ['transactional', 'financial']
	end

	def set_accounts
	  @accounts = Account.where(active: true).order(:id)
	end

	def month_total(months, account)
	  @total = 0.to_f
	  months.each do |m|
	  	if account.increases.downcase == m.flow
			@total += m.amount
	  	else
			@total -= m.amount
	  	end
	  end
	  @total
    end

	helper_method :month_total

	def create_journal_entry(journal, amount, account, flow)
		new_entry = journal.entries.new
		new_entry.amount = amount
		new_entry.account_id = account
		new_entry.flow = flow
		new_entry.save
	end


end
