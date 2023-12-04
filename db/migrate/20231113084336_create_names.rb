class CreateNames < ActiveRecord::Migration[7.1]
  def change
    create_table :names do |t|
      t.string :full_name
      t.string :gender
      t.string :country

      t.timestamps
    end
  end
end
