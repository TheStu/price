desc "Populate merchants table from AV feed"
task :update_merchant_table => :environment do
  require 'open-uri'
  require 'nokogiri'

  url = "https://www.avantlink.com/api.php?affiliate_id=31645&auth_key=#{ENV['AV_AUTH_KEY']}&module=AssociationFeed&output=xml&association_status=active"

  doc = Nokogiri::XML(open(url))
  doc.search('//Table1').each do |merchant|
    if Merchant.find_by_merchant_id(merchant.css('Merchant_Id').text).blank? && merchant.css('Merchant_Id').text != ('10048' or '10665')
      m = Merchant.new( :merchant_id => merchant.css('Merchant_Id').text,
                        :merchant_name => merchant.css('Merchant_Name').text,
                        :merchant_url => merchant.css('Merchant_URL').text,
                        :datafeed_url => 'http://')
      m.save
    end
  end
end

desc "check for price alert matches"
task :check_for_price_alert_matches => :environment do
  require 'open-uri'
  require 'nokogiri'

  Merchant.all.each do |merchant|
    url = merchant.datafeed_url

    results = Nokogiri::XML(open(url))

    Alert.where("merchant_id = ?", merchant.merchant_id).each do |alert|
      if results.xpath("//Product[contains(SKU/text(), #{alert.product_sku})]").present?
        found = results.xpath("//Product[contains(SKU/text(), #{alert.product_sku})]")
        if merchant.merchant_id == (10765 or 11481 or 10821 or 10923 or 11027 or 10601 or 10881)
          if found.css('/Retail_Price').text.to_f <= alert.price.to_f
            AlertMailer.registration_confirmation(alert.user, alert, found.css('/Buy_Link').text, found.css('/Retail_Price').text).deliver
            alert.destroy
          end
        else
          if found.css('/Sale_Price').text.to_f <= alert.price.to_f
            AlertMailer.registration_confirmation(alert.user, alert, found.css('/Buy_Link').text, found.css('/Sale_Price').text).deliver
            alert.destroy
          end
        end
      end
    end
  end
end
