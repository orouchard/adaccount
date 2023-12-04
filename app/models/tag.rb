class Tag < ApplicationRecord
	has_many :user_tag_joins, dependent: :destroy
	has_many :users, through: :user_tag_joins
end
