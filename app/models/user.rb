class User < ActiveRecord::Base
  has_one :bill
  has_many :items, through: :bill
  has_many :diary_logs
  has_many :user_activities

  def add_diary(content)
    diary_logs.create(content: content.sub(/Po /, ''))
  end
end
