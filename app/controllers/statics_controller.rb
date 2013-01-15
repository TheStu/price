class StaticsController < ApplicationController
  def home
    @query = (params[:q].present? ? params[:q] : '')
    @brand = (params[:b].present? ? params[:b] : '')
    @merchants = (params[:merchants].present? ? params[:merchants].join('%7C') : '10072%7C10032%7C10239%7C10260%7C10048%7C10060%7C10008%7C10765%7C10971%7C10063%7C10785%7C11233%7C10469%7C10537%7C11501%7C10485%7C10761%7C10965%7C11481%7C10821%7C10071%7C10597%7C10068%7C10076%7C10075%7C10263%7C10248%7C10923%7C10049%7C10869%7C11027%7C10921%7C10279%7C10345%7C10593%7C10280%7C10337%7C10073%7C10601%7C10881')
    @max = (params[:max].present? ? params[:max] : 100000)
    @min = (params[:min].present? ? params[:min] : 1)
    @sale_only = (params[:s].present? ? params[:s] : 0)
    @order = (params[:o].present? ? params[:o] : 'Match+Score%7Cdesc')
    @results = search_results(@query, @merchants, @brand, @sale_only, @min, @max, @order)
  end

  def advanced
  end

  def about
  end

  def contact
  end

  def private
  end

  private

  def search_results(query, merchants, brand, sale, price_min, price_max, order)
    require 'open-uri'
    require 'nokogiri'

    url = "http://www.avantlink.com/api.php?affiliate_id=31645&module=ProductSearch&output=xml&website_id=127225&search_term=#{CGI.escape(query)}&merchant_ids=#{merchants}&search_brand=#{CGI.escape(brand)}&search_on_sale_only=#{sale}&search_price_minimum=#{price_min}&search_price_maximum=#{price_max}&search_results_fields=Merchant+Name%7CSubcategory+Name%7CCategory+Name%7CDepartment+Name%7CProduct+Name%7CBrand+Name%7CRetail+Price%7CSale+Price%7CAbbreviated+Description%7CThumbnail+Image%7CBuy+URL%7CProduct+SKU%7CMerchant+Id&search_results_count=100&search_results_sort_order=#{order}&search_results_options=precise"
    results = Nokogiri::XML(open(url))
    my_hash = results.search('//Table1').map{ |e| Hash.from_xml(e.to_xml)['Table1'] }
  end
end

