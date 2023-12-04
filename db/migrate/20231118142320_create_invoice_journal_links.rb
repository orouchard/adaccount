class CreateInvoiceJournalLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :invoice_journal_links do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :journal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
