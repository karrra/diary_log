class Item < ActiveRecord::Base
  default_scope {order('created_at desc')}
  belongs_to :bill

  enum item_type: {
    other:     0,
    food:      1,
    shopping:  2,
    living:   3,
    transport: 4,
    leisure:   5
  }

  def self.month
    where("strftime('%m', created_at) = ?", Time.now.strftime('%m'))
  end
end
