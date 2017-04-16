class Item < ActiveRecord::Base
  default_scope {order('created_at desc')}
  belongs_to :bill
  scope :expense, -> {where.not(item_type: 6)}

  enum item_type: {
    other:     0,
    food:      1,
    shopping:  2,
    living:    3,
    transport: 4,
    leisure:   5,
    incomes:   6
  }

  def self.month(month=nil)
    month ||= Time.now.strftime('%Y年%m月')
    where("strftime('%Y年%m月', items.created_at) = ?", month)
  end
end
