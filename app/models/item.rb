class Item < ActiveRecord::Base
  default_scope {order('record_at desc')}

  belongs_to :bill
  belongs_to :parent_type, foreign_key: 'parent_type_id', class_name: 'ItemType'
  belongs_to :child_type, foreign_key: 'child_type_id', class_name: 'ItemType'

  TODAY = Time.current

  enum inorout: {
    expense: 0,
    incomes: 1
  }

  def self.year
    filter_data_by_duration(TODAY.at_beginning_of_year, TODAY.at_end_of_year)
  end

  def self.month(date=nil)
    date ||= TODAY
    filter_data_by_duration(date.at_beginning_of_month, date.at_end_of_month)
  end

  def self.quarter
    date = TODAY.at_end_of_month
    filter_data_by_duration(date - 2.months, date)
    where('record_at > ?', TODAY.at_beginning_of_month - 2.months)
  end

  def self.week
    filter_data_by_duration(TODAY.at_beginning_of_week, TODAY.at_end_of_week)
  end

  def self.day
    filter_data_by_duration(TODAY.at_beginning_of_day, TODAY.at_end_of_day)
  end

  def self.filter_data_by_duration(time_from, time_to)
    where('record_at >= ? and record_at <= ?', time_from, time_to)
  end
end
