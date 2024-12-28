class AddCommentFavoriteIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :comment_favorite_id, :integer
  end
end
