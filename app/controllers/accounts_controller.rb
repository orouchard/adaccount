class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy toggle ]

  # GET /accounts or /accounts.json
  def index
    @accounts = Account.all.order(:account_number)
  end

  # GET /accounts/1 or /accounts/1.json
  def show
    @entries = @account.entries.joins(:journal).merge(Journal.order(:date)) 
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts or /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to account_url(@account), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def toggle
    if @account.active
      @account.update!(active: false)
    else
      @account.update!(active: true)
    end
    redirect_to accounts_path
  end
  
  def month_account_sum
    @account = Account.find(params[:id])
    base_date = DateTime.parse("#{params[:year]}-#{params[:month]}-15")
    @start_date, @end_date = base_date.beginning_of_month, base_date.end_of_month
    @entries = Entry.includes(:journal).month_entries(@account, @start_date, @end_date)
    month_total(@entries, @account)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:account_number, :title, :increases, :description, :group, :subgroup, :statement, :active)
    end
end
