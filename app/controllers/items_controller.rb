class ItemsController < ApplicationController
  before_action :get_item, except: [:index, :stat, :fetch_data, :get_children_type]

  def index
    @items = @user.items.group_by{|i| i.record_at.to_date} rescue []
  end

  def edit
  end

  def update
    @item.update(item_params)
    @items = @user.items.group_by{|i| i.record_at.to_date} rescue []
  end

  def destroy
    @item.destroy
    @items = @user.items.group_by{|i| i.record_at.to_date} rescue []
  end

  def stat
  end

  def fetch_data
    @month = params[:month].present? ? params[:month] : Time.now.strftime('%Y年%m月')
    items = @user.bill.items.month(@month)
    result = items.expense.group(:parent_type_name).sum(:amount)
    @total_incomes = items.incomes.sum(:amount)
    @total_expense = items.expense.sum(:amount)
    @label = result.keys
    @record = result.keys.map{|i| result[i] && result[i].to_f}.compact
  end

  def get_children_type
    @result = ItemType.where(parent_id: params[:parent_id]).uniq.pluck(:id, :name)
    render json: @result
  end

  private
  def get_item
    @item = Item.find params[:id]
  end

  def item_params
    params.require(:item).permit(:parent_type_name, :parent_type_id, :child_type_name, :child_type_id, :amount, :memo, :record_at)
  end
end
