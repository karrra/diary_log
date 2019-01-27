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
    @monthly = fetch_chart_data(items, 'monthly')
  end

  def quarterly_report
    items = @user.items.quarter
    @weekly = fetch_chart_data(items, 'weekly')
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

  def fetch_chart_data(items, type)
    data = items.group_by{|i| type == 'monthly' ? i.record_at.strftime('%b') : i.record_at.strftime("%G-%V")}.reverse_each.to_h
    @total_expense = items.expense.sum(:amount)
    @total_incomes = items.incomes.sum(:amount)

    labels = type == 'monthly' ? data.keys : data.keys.map{|i| year, week = i.split('-'); Date.commercial(year.to_i, week.to_i, 1).strftime('%-m/%-d')}
    {
      labels: labels,
      expense: data.values.map{|i| i.inject(0){|sum, item| item.expense? ? sum + item.amount : sum}},
      incomes: data.values.map{|i| i.inject(0){|sum, item| item.incomes? ? sum + item.amount : sum}}
    }
  end
end
