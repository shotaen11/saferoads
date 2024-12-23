class CommentsController < ApplicationController
  # コメントを作成する
  def create
    @road_condition = RoadCondition.find(params[:road_condition_id])
    @comment = current_user.comments.new(comment_params)
    @comment.road_condition_id = @road_condition.id
    if @comment.save
      # 通知を作成する
      Notification.create!(
        user_id: @road_condition.user_id,  # 投稿者に通知
        visitor_id: current_user.id,       # コメントしたユーザー
        road_condition_id: @road_condition.id,
        action: 'comment',                 # アクションをコメントとする
        comment_id: @comment.id           # コメントIDを通知に含める
      )
      redirect_to road_condition_path(@road_condition)
    else
      @comments = @road_condition.comments.page(params[:page]).per(7).reverse_order
      render 'road_conditions/show', status: :unprocessable_entity
    end
  end
  

  # コメントを削除する
  def destroy
    Comment.find_by(id: params[:id], road_condition_id: params[:road_condition_id])&.destroy
    redirect_to road_condition_path(params[:road_condition_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
