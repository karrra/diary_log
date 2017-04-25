class DiaryLogsController < ApplicationController
  before_action :get_log, except: :index

  def index
    @logs = @user.diary_logs
  end

  def edit
  end

  def update
    if @log.update(log_params)
      redirect_to diary_logs_path
    else
      render 'edit'
    end
  end

  def destroy
    @log.destroy
    redirect_to diary_logs_path
  end

  private
  def get_log
    @log = @user.diary_logs.find params[:id]
  end

  def log_params
    params.require(:diary_log).permit(:content)
  end
end
