class LineItemsController < ApplicationController
  before_action :set_invoice, except: %i[ edit ]
  before_action :set_line_item, only: %i[ edit update destroy ]
  
  def create
    @line = @invoice.line_items.new(line_item_params)
    
    respond_to do |format|
      if @line.save
        @invoice.update_total
        format.html { redirect_to @invoice, notice: "The line was successfully created." }
        format.json { render :show, status: :created, location: @line }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @invoice = @line_item.invoice
    @line_items = @invoice.line_items
  end

  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        @invoice.update_total
        format.html { redirect_to @invoice, notice: "The line was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item.destroy!
    
    respond_to do |format|
      @invoice.update_total
      format.html { redirect_to @invoice, notice: "The line was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_line_item
    @line_item = LineItem.find params[:id]
  end
  
  def set_invoice
    @invoice = Invoice.find params[:invoice_id]
  end
  
  def line_item_params
    params.require(:line_item).permit(:invoice_id, :product_id, :price, :factor, :nbr, :note, :amount, :active)
  end
end
