class CommentsController < ApplicationController
  # コメントを作成するアクション
  def create
    @road_condition = RoadCondition.find(params[:road_condition_id]) # 対象となるRoadConditionを取得
    @comment = current_user.comments.new(comment_params)              # 現在のユーザーが新しいコメントを作成
    @comment.road_condition_id = @road_condition.id                   # コメントに関連付けるRoadConditionのIDを設定

    if @comment.save
      # コメントが正常に保存された場合、投稿者に通知を作成
      Notification.create!(
        visited_id: @road_condition.user_id,  # 投稿者に通知
        visitor_id: current_user.id,          # コメントしたユーザー
        road_condition_id: @road_condition.id, # コメントが関連するRoadConditionのID
        action: 'comment',                    # アクションを'comment'として通知
        comment_id: @comment.id               # 通知にコメントIDを含める
      )
      # コメントが保存されたら、そのRoadConditionの詳細ページにリダイレクト
      redirect_to road_condition_path(@road_condition)
    else
      # コメントが保存できなかった場合、エラーメッセージを表示し、コメント一覧を再表示
      @comments = @road_condition.comments.page(params[:page]).per(7).reverse_order
      render 'road_conditions/show', status: :unprocessable_entity
    end
  end

  # コメントを削除するアクション
  def destroy
    # 指定されたコメントと関連するRoadConditionを削除
    Comment.find_by(id: params[:id], road_condition_id: params[:road_condition_id])&.destroy
    # コメント削除後、関連するRoadConditionの詳細ページにリダイレクト
    redirect_to road_condition_path(params[:road_condition_id])
  end

  private

  # コメントのパラメータを許可
  def comment_params
    params.require(:comment).permit(:comment) # コメント内容のみを許可
  end
end
