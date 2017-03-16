class ItemsController < ApplicationController
  before_action :get_item, except: [:index, :stat, :fetch_data]
  before_action :get_bill, only: [:index, :stat, :fetch_data]

  def index
    @items = @user.items.group_by{|i| i.created_at.to_date} rescue []
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to items_url, notice: '修改成功'
    else
      render 'edit'
    end
  end

  def destroy
    if @item.destroy
      redirect_to items_url, notice: '删除成功'
    else
      render 'edit'
    end
  end

  def stat
  end

  def fetch_data
    items = @user.bill.items.month.group(:item_type).sum(:amount)
    render json: Item.item_types.map{|k, v| items[v].to_f}
  end

  private
  def get_bill
    session[:open_id] ||= params[:open_id]
    @user = User.where(open_id: session[:open_id]).first
  end

  def get_item
    @item = Item.find params[:id]
  end

  def item_params
    params.require(:item).permit(:item_type, :amount, :memo)
  end
end
