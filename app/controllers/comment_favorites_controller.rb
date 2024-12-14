class CommentFavoritesController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @comment = Comment.find(params[:comment_id])
      current_user.favorite_comment(@comment)
  
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
  