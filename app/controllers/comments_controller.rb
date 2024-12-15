class CommentsController < ApplicationController
    # コメントを作成する
    def create
        @road_condition = RoadCondition.find(params[:road_condition_id])
        @comment = current_user.comments.new(comment_params)
        @comment.road_condition_id = @road_condition.id
        if @comment.save
        # 通知を作成
          @road_condition.create_notification_comment!(current_user, @comment.id)
        
          redirect_to road_condition_path(@road_condition)
        else
          # @commentを再描画時にも利用可能にするため初期化
          @comments = @road_condition.comments.page(params[:page]).per(7).reverse_order
          render 'road_conditions/show', status: :unprocessable_entity
        end
      end
      
  
    # コメントを削除する
    def destroy
      # コメントを検索して削除
      Comment.find_by(id: params[:id], road_condition_id: params[:road_condition_id]).destroy
      # 削除後は該当の道路状況詳細ページにリダイレクト
      redirect_to road_condition_path(params[:road_condition_id])
    end
  
    private
  
    # コメントのパラメータを許可
    def comment_params
      params.require(:comment).permit(:comment)
    end
  end
  