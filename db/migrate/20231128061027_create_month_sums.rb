class CreateMonthSums < ActiveRecord::Migration[7.1]
  def change
    create_table :month_sums do |t|
      t.datetime :date
      t.references :account, null: false, foreign_key: true
      t.float :amount
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
