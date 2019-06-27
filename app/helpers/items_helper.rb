module ItemsHelper
  def item_type_icon(item_type)
    icon =
      case item_type
      when '餐饮'
        'fa-coffee'
      when '购物消费'
        'fa-shopping-cart'
      when '居家生活'
        'fa-home'
      when '交通费'
        'fa-train'
      when '休闲娱乐'
        'fa-gamepad'
      when '健康医疗'
        'fa-hospital'
      when '文化教育'
        'fa-book'
      when '收入'
        'fa-money-bill-alt'
      else
        'fa-credit-card'
      end
    "<i class='fa #{icon}'></i>".html_safe
  end
end
