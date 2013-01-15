module ApplicationHelper
  def full_title(page_title) #Returns the full title on a per-page basis.
    base_title = "Camping Price Search"
    if page_title.empty?
      base_title
    elsif page_title == "home"
      "#{base_title} | The Lowest Price for your Camping Gear"
    else
      "#{page_title} | #{base_title}"
    end
  end

  def meta_desc(desc) #Returns the full title on a per-page basis.
    if desc.empty?
      "Price search and price alerts for hiking, backpacking and camping gear"
    else
      desc
    end
  end

  def pretty_date(date)
    date = date.to_date
    new_date = date.strftime("%b #{date.day.ordinalize}, %Y")
  end

  def pretty_name(result)
    if result['Brand'].present?
      "#{result['Brand'].titleize} #{result['Product_Name'].gsub("#{result['Brand']} ", '').titleize}"
    else
      result['Product_Name'].titleize
    end
  end

  def flash_class(level) #change rails alerts in to bootstrap alerts (associated partial and application.html code)
   case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end
end
