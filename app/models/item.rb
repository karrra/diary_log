class Item < ActiveRecord::Base
  default_scope {order('record_at desc')}
  belongs_to :bill
  belongs_to :parent_type, foreign_key: 'parent_type_id', class_name: 'ItemType'
  belongs_to :child_type, foreign_key: 'child_type_id', class_name: 'ItemType'

  enum inorout: {
    expense: 0,
    incomes: 1
  }

  def self.year
    where('extract(year from record_at) = ?', Date.current.year)
  end

  def self.month(date=nil)
    date ||= Date.current
    where('extract(year from record_at) = ? AND extract(month from record_at) = ?', date.year, date.month)
  end

  def self.quarter
    where('record_at > ?', Time.current.at_beginning_of_month - 2.months)
  end

  def self.week
    date = Date.current
    where('extract(year from record_at) = ? AND extract(week from record_at) = ?', date.year, date.cweek)
  end

  def self.day
    date = Date.current
    where('extract(year from record_at) = ? AND extract(doy from record_at) = ?', date.year, date.yday)
  end
end
