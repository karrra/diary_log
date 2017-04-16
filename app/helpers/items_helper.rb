module ItemsHelper
  def item_type_icon(item_type)
    icon =
      case item_type
      when 'food'
        'fa-cutlery'
      when 'shopping'
        'fa-shopping-cart'
      when 'living'
        'fa-home'
      when 'transport'
        'fa-train'
      when 'leisure'
        'fa-music'
      when 'incomes'
        'fa-money'
      else
        'fa-credit-card'
      end
    "<i class='fa #{icon}'></i>".html_safe
  end
end
