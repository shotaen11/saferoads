class Notification < ApplicationRecord
  # scope :unchecked, -> { where(checked: false) }
  scope :unchecked, -> { where(checked: false).or(where(action: 'follow', checked: false)) }

  belongs_to :road_condition, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'

  validates :action, presence: true
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  validates :road_condition_id, presence: true, if: :road_condition_action?
  validates :comment_id, presence: true, if: :comment_action?

  validates :checked, inclusion: { in: [true, false] }

  # `follow` アクションの場合
  def follow_action?
    action == 'follow'
  end

  def road_condition_action?
    action == 'road_condition'
  end

  def comment_action?
    action == 'comment'
  end

  def comment_favorite_action?
    action == 'comment_favorite'
  end
end
