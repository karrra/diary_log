class User < ActiveRecord::Base
  has_one :bill
  has_many :items, through: :bill
  has_many :diary_logs
  has_many :user_activities

  after_commit :attach_bill

  private
  def attach_bill
    self.create_bill
  end
end
