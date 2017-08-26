class Item < ActiveRecord::Base
  default_scope {order('record_at desc')}
  belongs_to :bill
  belongs_to :parent_type, foreign_key: 'parent_type_id', class_name: 'ItemType'
  belongs_to :child_type, foreign_key: 'child_type_id', class_name: 'ItemType'

  enum inorout: {
    expense: 0,
    incomes: 1
  }

  def self.month(month=nil)
    month ||= Time.now.strftime('%Y年%m月')
    where("strftime('%Y年%m月', items.record_at) = ?", month)
  end

  def self.week
    where("strftime('%W', items.record_at) = ?", Time.now.strftime('%W'))
  end
end
