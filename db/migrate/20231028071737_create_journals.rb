class CreateJournals < ActiveRecord::Migration[7.1]
  def change
    create_table :journals do |t|
      t.datetime :date
      t.string :description
      t.string :currency
      t.string :trans_nat
      t.boolean :balanced, default: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
