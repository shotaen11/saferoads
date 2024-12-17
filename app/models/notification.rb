class Notification < ApplicationRecord
  scope :unchecked, -> { where(checked: false) }

  belongs_to :road_condition, optional: true
  belongs_to :comment, optional: true

  belongs_to :visiter, class_name: 'User', foreign_key: 'visiter_id'
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'

  validates :action, presence: true
  validates :visiter_id, presence: true
  validates :visited_id, presence: true
  validates :road_condition_id, presence: true
  validates :comment_id, presence: true
end
