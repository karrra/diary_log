class PageController < ApplicationController
  def report
    daily_data = Item.month.group_by{|i| i.record_at.day}
    @daily = {
      labels: daily_data.keys,
      expense: daily_data.values.map{|i| i.count{|i| i.expense?}},
      incomes: daily_data.values.map{|i| i.count{|i| i.incomes?}}
    }

    monthly_data = Item.year.group_by{|i| i.record_at.month}
    @monthly = {
      labels: monthly_data.keys,
      expense: monthly_data.values.map{|i| i.count{|i| i.expense?}},
      incomes: monthly_data.values.map{|i| i.count{|i| i.incomes?}}
    }
  end
end
