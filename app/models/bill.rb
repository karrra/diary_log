class Bill < ActiveRecord::Base
  belongs_to :user
  has_many :items

  def add_item(content)
    memo, amount = content.split(' ')
    return false unless amount
    item = Item.new(bill_id: self.id, memo: memo)
    data = YAML.load_file(Rails.root.join('config/dictionary.yml'))['item_type']
    i_type = data.find{|k, v| memo.in? v}.first rescue nil
    i_type = i_type.present? ? i_type : 0
    amount = i_type == 'incomes' ? amount : amount.to_f * -1
    item.update(item_type: i_type, amount: amount)
  end

  def month_total_expense
    items.expense.month.sum(:amount)
  end

  def month_total_income
    items.incomes.month.sum(:amount)
  end
end
