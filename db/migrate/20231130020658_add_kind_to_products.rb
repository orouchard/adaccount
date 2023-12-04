class AddKindToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :kind, :string
  end
end
