class Alert < ActiveRecord::Base
  attr_accessible :price_cents, :price, :merchant_id, :product_sku,
  :user_id, :product_name

  attr_accessor :best_price

  monetize :price_cents

  belongs_to :user
end
