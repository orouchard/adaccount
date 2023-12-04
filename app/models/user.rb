class User < ApplicationRecord
	has_many :invoices, dependent: :destroy
	has_many :user_tag_joins, dependent: :destroy
	has_many :tags, through: :user_tag_joins
	
	validates_presence_of [:title, :name, :nationality]
end
