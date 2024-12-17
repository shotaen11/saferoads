class CommentFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.find(params[:comment_id])
    @road_condition = @comment.road_condition # コメントに関連するRoadConditionを取得

    current_user.favorite_comment(@comment)
    # 通知の作成
    @comment.user.create_notification_comment_favorite!(current_user, @comment.id)
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    current_user.unfavorite_comment(@comment)
  end
end
