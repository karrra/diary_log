class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_user

  private
  def get_user
    session[:open_id] ||= params[:open_id]
    @user = User.where(open_id: session[:open_id]).first
  end
end
