class ItemsController < ApplicationController
  before_action :get_item, only: [:edit, :update, :destroy]

  def index
    get_items
    add_activity({
      action: 'Get',
      ip: request.remote_ip,
      detail: 'get items list'
    })
  end

  def edit
  end

  def update
    @item.attributes = item_params
    set_inorout(@item)
    get_items
    add_activity({
      action: 'Update',
      ip: request.remote_ip,
      detail: 'update item'
    })
  end

  def destroy
    @item.destroy
    get_items
    add_activity({
      action: 'Destroy',
      ip: request.remote_ip,
      detail: 'destroy item'
    })
  end

  def stat
    add_activity({
      action: 'Get',
      ip: request.remote_ip,
      detail: 'get items stat'
    })
  end

  def fetch_data
    @month = params[:month].present? ? params[:month] : Time.current.strftime('%Y/%m')
    items = @user.bill.items.month(Date.parse(@month))
    result = items.expense.group_by(&:parent_type_name)
    @total_incomes = items.incomes.sum(:amount)
    @total_expense = items.expense.sum(:amount)
    @label = result.keys
    @record = @label.map{|i| result[i] && result[i].sum(&:amount).to_f}.compact
  end

  def get_children_type
    @result = ItemType.where(parent_id: params[:parent_id]).uniq.pluck(:id, :name)
    render json: @result
  end

  def annual_report
    items = @user.items.year
    monthly_data = items.group_by{|i| i.record_at.strftime('%b')}.reverse_each.to_h
    @total_expense = items.expense.sum(:amount)
    @total_incomes = items.incomes.sum(:amount)
    @monthly = {
      labels: monthly_data.keys,
      expense: monthly_data.values.map{|i| i.inject(0){|sum, item| item.expense? ? sum + item.amount : sum}},
      incomes: monthly_data.values.map{|i| i.inject(0){|sum, item| item.incomes? ? sum + item.amount : sum}}
    }
  end

  def weekly_report
    items = @user.items.expense.quarter
    weekly_data = items.group_by{|i| i.record_at.strftime('%W')}.reverse_each.to_h
    @total_expense = items.sum(:amount)
    @weekly = {
      labels: weekly_data.keys.map{|week_number| Date.commercial(Date.current.year, week_number.to_i, 1).strftime('%-m/%-d')},
      expense: weekly_data.values.map{|i| i.inject(0){|sum, item| sum + item.amount}},
    }
  end

  private
  def get_item
    @item = Item.find params[:id]
  end

  def get_items
    @items = @user.items.group_by{|i| i.record_at.to_date} rescue []
    @item_keys = @items.keys.paginate(page: params[:page], per_page: 20)
  end

  def item_params
    params.require(:item).permit(:parent_type_name, :parent_type_id, :child_type_name, :child_type_id, :amount, :memo, :record_at)
  end

  def add_activity(options)
    if @user.present?
      @user.user_activities.create(
        action: options[:action],
        ip_address: options[:ip],
        detail: options[:detail]
      )
    end
  end

  def set_inorout(item)
    item.inorout = item.parent_type_name == '收入' ? 'incomes' : 'expense'
    item.save
  end
end
