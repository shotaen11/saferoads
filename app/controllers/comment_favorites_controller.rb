class CommentFavoritesController < ApplicationController
  # ユーザーがログインしていない場合はアクセスできないようにする
  before_action :authenticate_user!

  # コメントにいいね（お気に入り）を追加するアクション
  def create
    @comment = Comment.find(params[:comment_id]) # いいねをつけるコメントを取得
    @road_condition = @comment.road_condition    # コメントに関連するRoadConditionを取得

    # 現在のユーザーがコメントにいいねをつける
    current_user.favorite_comment(@comment)

    # コメントの投稿者に通知を作成
    Notification.create!(
      visited_id: @comment.user_id,  # コメントの投稿者に通知
      visitor_id: current_user.id,   # いいねをしたユーザー
      road_condition_id: @road_condition.id, # コメントに関連する道路状態ID
      action: 'comment_favorite',    # アクション名を'comment_favorite'として通知
      comment_id: @comment.id        # 通知にコメントIDを含める
    )

    # Turbo Streamを使用して非同期でビューを更新
    respond_to do |format|
      format.turbo_stream
    end
  end

  # コメントのいいね（お気に入り）を削除するアクション
  def destroy
    @comment = Comment.find(params[:comment_id]) # いいねを外すコメントを取得
    # 現在のユーザーがコメントからいいねを外す
    current_user.unfavorite_comment(@comment)

    # Turbo Streamを使用して非同期でビューを更新
    respond_to do |format|
      format.turbo_stream
    end
  end
end
