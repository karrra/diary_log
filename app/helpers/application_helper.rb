module ApplicationHelper
  def time_format(datetime)
    if datetime.present?
      datetime.strftime('%Y-%m-%d %H:%M')
    else
      nil
    end
  end

  def month_format(datetime)
    if datetime.present?
      datetime.strftime('%Y/%m')
    else
      nil
    end
  end

  def get_months_number
    result = []
    3.times.each do |i|
      result << (Date.current - i.month).month
    end
    result
  end

end
