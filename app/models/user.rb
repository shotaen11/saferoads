class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :road_conditions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comment_favorites, dependent: :destroy

  # フォロー機能の関連付け
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower

  # プロフィール画像
  attachment :profile_image

  # フォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # フォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしている場合、trueを返す
  def following?(user)
    following_user.include?(user)
  end
end
