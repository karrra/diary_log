class Bill < ActiveRecord::Base
  belongs_to :user
  has_many :items

  def add_item(content)
    memo, amount = content.split(' ')
    return false if amount.to_i.zero?
    data = YAML.load_file(Rails.root.join('config/dictionary.yml'))['item_type']
    result = data.find{|k, v| memo.in? v}.first rescue nil
    item = Item.create(bill_id: self.id, memo: memo, amount: amount)
    if result.present?
      item.update(item_type: result)
    else
      item.update(item_type: 0)
    end
  end

  def month_total
    items.month.sum(:amount)
  end
end
