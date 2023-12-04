class AddDueDateToPeriods < ActiveRecord::Migration[7.1]
  def change
    add_column :periods, :due_date, :date
  end
end
