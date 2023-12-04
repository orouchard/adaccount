class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.references :journal, null: false, foreign_key: true
      t.float :amount
      t.string :flow
      t.references :account, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
