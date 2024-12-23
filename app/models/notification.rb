class Notification < ApplicationRecord
  scope :unchecked, -> { where(checked: false) }

  belongs_to :road_condition, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'

  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :followed, class_name: 'User', foreign_key: 'followed_id'

  validates :action, presence: true
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  validates :road_condition_id, presence: true, if: :road_condition_action?
  validates :comment_id, presence: true, if: :comment_action?
  validates :follower_id, presence: true, if: :follow_action?
  validates :followed_id, presence: true, if: :follow_action?

  # actionが'follow'の場合、follower_idとfollowed_idが必須
  def follow_action?
    action == 'follow'
  end

  def road_condition_action?
    action == 'road_condition'
  end

  def comment_action?
    action == 'comment'
  end
end
