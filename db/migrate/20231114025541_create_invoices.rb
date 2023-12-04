class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency, default: "vnd"
      t.date :date_issue
      t.date :date_due
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
