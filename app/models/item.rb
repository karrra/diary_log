class Item < ActiveRecord::Base
  default_scope {order('record_at desc')}
  belongs_to :bill
  belongs_to :parent_type, foreign_key: 'parent_type_id', class_name: 'ItemType'
  belongs_to :child_type, foreign_key: 'child_type_id', class_name: 'ItemType'

  enum inorout: {
    expense: 0,
    incomes: 1
  }

  def self.month(date=nil)
    date ||= Date.today
    where('extract(year from record_at) = ? AND extract(month from record_at) = ?', date.year, date.month)
  end

  def self.week
    date = Date.today
    where('extract(year from record_at) = ? AND extract(week from record_at) = ?', date.year, date.cweek)
  end
end
