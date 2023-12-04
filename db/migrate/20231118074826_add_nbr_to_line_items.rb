class AddNbrToLineItems < ActiveRecord::Migration[7.1]
  def change
    add_column :line_items, :nbr, :integer
  end
end
