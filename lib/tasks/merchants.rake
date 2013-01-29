desc "Populate merchants table from AV feed"
task :update_merchant_table => :environment do
  require 'open-uri'
  require 'nokogiri'

  url = "https://www.avantlink.com/api.php?affiliate_id=31645&auth_key=#{ENV['AV_AUTH_KEY']}&module=AssociationFeed&output=xml&association_status=active"

  doc = Nokogiri::XML(open(url))
  doc.search('//Table1').each do |merchant|
    if Merchant.find_by_merchant_id(merchant.css('Merchant_Id').text).blank? && !['10048', '10665'].include?(merchant.css('Merchant_Id').text)
      m = Merchant.new( :merchant_id => merchant.css('Merchant_Id').text,
                        :merchant_name => merchant.css('Merchant_Name').text,
                        :merchant_url => merchant.css('Merchant_URL').text)
      m.save
    end
  end
end

desc "check for price alert matches"
task :check_for_price_alert_matches => :environment do
  require 'open-uri'
  require 'nokogiri'

  Merchant.all.each do |merchant|
    url = merchant.datafeed_url + '&from=2012-1-26'

    results = Nokogiri::XML(open(url))

    Alert.where("merchant_id = ?", merchant.merchant_id).each do |alert|
      if results.xpath("/Products/Product[SKU/text()='#{alert.product_sku}']").present?
        found = results.xpath("/Products/Product[SKU/text()='#{alert.product_sku}']")
        if [10765, 11481, 10821, 10923, 11027, 10601, 10881, 11419].include?(merchant.merchant_id)
          if found.xpath('Retail_Price').text.to_f <= alert.price.to_f
            AlertMailer.price_alert(alert.user, alert, found.xpath('Buy_Link').text, found.xpath('Retail_Price').text).deliver
            alert.destroy
          end
        else
          if found.xpath('Sale_Price').text.to_f <= alert.price.to_f
            AlertMailer.price_alert(alert.user, alert, found.xpath('Buy_Link').text, found.xpath('Sale_Price').text).deliver
            alert.destroy
          end
        end
      end
    end
  end
end
