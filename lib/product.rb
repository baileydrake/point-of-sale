class Product < ActiveRecord::Base
  has_many :carts
  has_many :sales, through: :carts
end
