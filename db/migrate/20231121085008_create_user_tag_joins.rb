class CreateUserTagJoins < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tag_joins do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
