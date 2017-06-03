class ItemType < ActiveRecord::Base
  has_many :items, foreign_key: 'parent_type_id'

  scope :parents_type, -> { where(parent_id: nil) }

  enum level: {
    top: 0,
    bottom:  1
  }
end
