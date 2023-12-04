class CreateParams < ActiveRecord::Migration[7.1]
  def change
    create_table :params do |t|
      t.string :group
      t.string :value
      t.string :label
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :params, :group
  end
end
