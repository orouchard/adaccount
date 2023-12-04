class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.date :date_from
      t.date :date_to
      t.float :amount
      t.string :currency, default: 'vnd'
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
