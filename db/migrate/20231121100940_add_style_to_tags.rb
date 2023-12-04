class AddStyleToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :style, :string
  end
end
