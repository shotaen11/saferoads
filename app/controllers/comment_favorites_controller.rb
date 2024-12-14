class CommentFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.find(params[:comment_id])
    @road_condition = @comment.road_condition # コメントに関連するRoadConditionを取得

    current_user.favorite_comment(@comment)

    # 通知を作成
    create_notification(
      road_condition: @road_condition,
      visiter: current_user,
      visited: @road_condition.user,
      action: 'comment_favorites'
    )

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    current_user.unfavorite_comment(@comment)

    respond_to do |format|
      format.turbo_stream
    end
  end
end
