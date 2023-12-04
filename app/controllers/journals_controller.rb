class JournalsController < ApplicationController
  before_action :set_journal, only: %i[ show edit update destroy check ]
  before_action :set_trans_nat, only: %i[ new edit ]
  before_action :set_accounts, only: %i[ show ]
  before_action :set_invoice, only: %i[ wizard ]
  before_action :validates_wizz, only: %i[ wizard ] # validates the  form on the wizard action

  # GET /journals or /journals.json
  def index
    @journals = Journal.includes(:entries).all.order(:id)
  end

  # GET /journals/1 or /journals/1.json
  def show
    @entries = @journal.entries.order(:id)
    is_balanced?
    # debit_credit_entries
  end

  # GET /journals/new
  def new
    @journal = Journal.new
  end

  # GET /journals/1/edit
  def edit
  end

  # POST /journals or /journals.json
  def create
    if params[:invoice_id]
      @invoice = Invoice.find(params[:invoice_id ])
      @journal = @invoice.journals.new(journal_params)
    else
      @journal = Journal.new(journal_params)
    end

    respond_to do |format|
      if @journal.save
        format.html { redirect_to journal_url(@journal), notice: "Journal was successfully created." }
        format.json { render :show, status: :created, location: @journal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /journals/1 or /journals/1.json
  def update
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to journal_url(@journal), notice: "Journal was successfully updated." }
        format.json { render :show, status: :ok, location: @journal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def check
    @entries = @journal.entries
    is_balanced?
    check_balanced
  end

  # DELETE /journals/1 or /journals/1.json
  def destroy
    @journal.destroy!

    respond_to do |format|
      format.html { redirect_to journals_url, notice: "Journal was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def wizard
    @dates.each do |date|
      temps_date = date.strftime("%B %Y")
      temps_amount = params["wizz"]["amount"].to_f / @dates.size
      journal = @invoice.journals.create!(date: date.end_of_month, description: (params["wizz"]["label"] + " - " + temps_date), currency: params["wizz"]["currency"], trans_nat: params["wizz"]["trans_nat"])
      journal.entries.create!(amount: temps_amount, flow: "debit",account_id: params["wizz"]["account_debit"] )
      journal.entries.create!(amount: temps_amount, flow: "credit",account_id: params["wizz"]["account_credit"] )
      
      @entries = journal.entries
      is_balanced?
      
      if @is_balanced == true
        journal.update(balanced: true)
      else
        journal.update(balanced: false)
      end
    end
    
    redirect_to_invoice(true)
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:invoice_id])
    end

    # Only allow a list of trusted parameters through.
    def journal_params
      params.require(:journal).permit(:date, :description, :currency, :trans_nat, :balanced, :active)
    end
    
    def is_balanced?
      
      @debit,@credit = 0,0
      
      @entries.each do |e|
        if e.flow == 'debit'
          @debit += e.amount
        elsif e.flow == 'credit'
          @credit += e.amount
        end
      end
      
      if @debit == @credit
        @is_balanced = true
      else
        @is_balanced = false
      end
    end
    
    def check_balanced
      if @is_balanced == true
        @journal.update(balanced: true)
        redirect_to journal_url(@journal), notice: "Journal is balanced."
      else
        @journal.update(balanced: false)
        redirect_to journal_url(@journal), notice: "Journal is not balanced."
      end
    end
    
    def validates_wizz
      if params["wizz"]["label"].empty? || params["wizz"]["amount"].empty? || params["wizz"]["trans_nat"].empty? || params["wizz"]["account_debit"].empty?  || params["wizz"]["account_credit"].empty? || params["wizz"]["dates"].size == 1
        redirect_to_invoice(false)
      else
        @dates = []
        params["wizz"]["dates"].drop(1).each do |d|
          @dates << Date.parse(d)
        end
      end
    end
    
    def redirect_to_invoice(status)
      if status
        redirect_to @invoice, notice: "Journal entries have been created"
      else
        redirect_to @invoice, notice: "The Wizard Form must be fully completed"
      end
    end
    
end
