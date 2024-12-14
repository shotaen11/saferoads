class Notification < ApplicationRecord
  scope :unchecked, -> { where(checked: false) }
  belongs_to :road_condition, optional: true
  belongs_to :visiter, class_name: 'User', foreign_key: 'visiter_id'
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'
  belongs_to :comment, optional: true

  validates :action, presence: true
end
