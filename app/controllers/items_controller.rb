class ItemsController < ApplicationController
  before_action :get_item, except: [:index, :stat, :fetch_data, :get_children_type]

  def index
    get_items
  end

  def edit
  end

  def update
    @item.update(item_params)
    get_items
  end

  def destroy
    @item.destroy
    get_items
  end

  def stat
  end

  def fetch_data
    @month = params[:month].present? ? params[:month] : Time.now.strftime('%Y/%m')
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
end
