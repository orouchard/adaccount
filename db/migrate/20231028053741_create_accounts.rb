class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.integer :account_number
      t.string :title
      t.string :increases
      t.string :description
      t.string :group
      t.string :subgroup
      t.string :statement
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
