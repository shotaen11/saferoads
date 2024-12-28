class CommentFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.find(params[:comment_id])
    @road_condition = @comment.road_condition # コメントに関連するRoadConditionを取得

    current_user.favorite_comment(@comment)

    # 通知を作成する
    Notification.create!(
      visited_id: @comment.user_id,  # コメントの投稿者に通知
      visitor_id: current_user.id,   # いいねをしたユーザー
      road_condition_id: @road_condition.id,
      action: 'comment_favorite',    # アクションをcomment_favoriteとする
      comment_id: @comment.id        # コメントIDを通知に含める
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
