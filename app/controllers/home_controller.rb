class HomeController < ApplicationController
  # before_action :set_months, only: %i[ index ]
  def index
    @d1 = Param.first_day
    @months_dur = Param.months_dur
    set_months
    build_is_groups
    
    
    @account = Account.find(39)
    @monthly_entries = Entry.month_entries(@account, begin_of_month("2024-12-01"), end_of_month("2024-12-01"))
  end
  
  private
  
  def begin_of_month(date)
    DateTime.parse(date).beginning_of_month
  end

  def end_of_month(date)
    DateTime.parse(date).end_of_month
  end

end
