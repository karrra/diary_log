include QueryItemType

class Bill < ActiveRecord::Base
  belongs_to :user
  has_many :items

  def add_item(content, msg_id)
    return false if Item.exists?(msg_id: msg_id)
    i_type = QueryItemType.get(content)
    return false unless i_type
    memo, amount = content.split(' ')
    return false unless amount

    Item.transaction do
      Item.create(
        bill_id: self.id,
        memo: memo,
        parent_type_id: i_type[:parent].id,
        parent_type_name: i_type[:parent].name,
        child_type_id: i_type[:child].id,
        child_type_name: i_type[:child].name,
        record_at: Time.now,
        inorout: i_type[:incomes],
        amount: amount,
        msg_id: msg_id
      )
    end
  end

  def month_total_expense
    items.expense.month.sum(:amount)
  end

  def month_total_income
    items.incomes.month.sum(:amount)
  end
end
