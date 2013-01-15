class Merchant < ActiveRecord::Base
  attr_accessible :merchant_id, :merchant_name, :merchant_url, :datafeed_url
end
