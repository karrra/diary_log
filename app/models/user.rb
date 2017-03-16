class User < ActiveRecord::Base
  has_one :bill
  has_many :items, through: :bill
end
