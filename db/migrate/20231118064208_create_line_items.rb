class CreateLineItems < ActiveRecord::Migration[7.1]
  def change
    create_table :line_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :note
      t.float :price
      t.float :factor
      t.float :amount
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
