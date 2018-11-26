require 'uri'
require 'net/http'

module QueryItemType
  URL = 'http://duo.qq.com/api/semantic?type=text&ctx='

  def get(content)
    begin
      if content.match(/收入/)
        data = {
          'parent_category_name' => '收入',
          'child_category_name' => '羊毛'
        }
      else
        response = Net::HTTP.get(URI.parse(URI::escape(URL + content)))
        data = JSON.parse(response)['data']
      end
      parent_type = ItemType.top.where(name: data['parent_category_name']).first_or_create
      child_type = ItemType.bottom.where(parent_id: parent_type.id, name: data['child_category_name']).first_or_create
      {
        parent: parent_type,
        child: child_type,
        incomes: parent_type.name == '收入' ? 1 : 0
      }
    rescue => e
      Rails.logger.error "======error: #{e}"
      nil
    end
  end
end
