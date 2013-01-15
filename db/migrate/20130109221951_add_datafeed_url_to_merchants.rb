class AddDatafeedUrlToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :datafeed_url, :string
  end
end
