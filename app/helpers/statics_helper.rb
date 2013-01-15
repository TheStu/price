module StaticsHelper
  def merch_name(result)
    name = result['Merchant_Name'].gsub('.com', '')
  end
end
