module ApplicationHelper
  def time_format(datetime)
    if datetime.present?
      datetime.strftime('%Y-%m-%d %H:%m')
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
end
