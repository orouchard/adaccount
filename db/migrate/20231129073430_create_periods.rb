class CreatePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :periods do |t|
      t.date :date_from
      t.date :date_to
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
