class ItemsController < ApplicationController
  before_action :get_item, except: [:index, :stat, :fetch_data]

  def index
    @items = @user.items.group_by{|i| i.created_at.to_date} rescue []
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to items_url
    else
      render 'edit'
    end
  end

  def destroy
    if @item.destroy
      redirect_to items_url
    else
      render 'edit'
    end
  end

  def stat
  end

  def fetch_data
    @month = params[:month].present? ? params[:month] : Time.now.strftime('%Y年%m月')
    items = get_current_month_items(@month)
    result = items.expense.group(:item_type).sum(:amount)
    @total_incomes = items.incomes.sum(:amount)
    @total_expense = items.expense.sum(:amount).abs
    @label = result.keys.map{|k| t("items.item_type.#{Item.item_types.key(k)}")}
    @record = result.keys.map{|i| result[i] && result[i].to_f.abs}.compact
  end

  private
  def get_current_month_items(month)
    @user.bill.items.month(month)
  end

  def get_item
    @item = Item.find params[:id]
  end

  def item_params
    params.require(:item).permit(:item_type, :amount, :memo)
  end
end
