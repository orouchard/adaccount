class AddTotalToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :total, :float
  end
end
