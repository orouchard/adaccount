class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]
  before_action :set_trans_nat, only: %i[ show ]
  before_action :set_accounts, only: %i[ show ]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.includes(:user)
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    # @prices = @invoices.prices
    @line_items = @invoice.line_items.includes(:product)
    @journals = @invoice.journals.includes(:entries).order(:date)
    
    # dates for journal wizard
    @d1 = Param.first_day
    @months_dur = Param.months_dur
    set_months
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    # fail
    if params[:user_id]
      @user = User.find(params[:user_id])
      @invoice = @user.invoices.new(invoice_params)
    else
      @invoice = Invoice.new(invoice_params)
    end
   
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:user_id, :currency, :date_issue, :date_due, :active, :description)
    end
end
