class UsersController < ApplicationController
  # ユーザーの一覧を表示する
  def index
    @users = User.page(params[:page]).per(5).reverse_order  # ページネーションでユーザー一覧を取得
  end

  # 特定のユーザーの詳細を表示
  def show
    @user = User.find(params[:id])  # ユーザーをIDで取得
    @road_conditions = @user.road_conditions.merge(RoadCondition.published_only).page(params[:page]).per(8).reverse_order  # ユーザーの公開された道路状況を取得
    @following_users = @user.following_user  # フォローしているユーザーを取得
    @follower_users = @user.follower_user  # フォロワーを取得
  end

  # ユーザー情報の編集フォームを表示
  def edit
    @user = User.find(params[:id])  # 編集対象のユーザーをIDで取得
  end

  # ユーザー情報を更新
  def update
    @user = User.find(params[:id])  # 更新対象のユーザーをIDで取得
    if @user.update(user_params)
      redirect_to user_path(@user.id)  # 更新成功後、ユーザー詳細ページにリダイレクト
    else
      render :edit, status: :unprocessable_entity  # 更新失敗時、再度編集フォームを表示
    end
  end

  # プロフィール画像を削除
  def remove_profile_image
    @user = User.find(params[:id])  
    if @user == current_user  # 現在のユーザーと一致する場合のみ削除
      @user.profile_image.purge  # プロフィール画像の削除
      redirect_to edit_user_path(@user), notice: 'プロフィール画像を削除しました'
    else
      redirect_to root_path, alert: '他のユーザーの画像は削除できません'  # 他ユーザーの画像を削除できない
    end
  end

  # ユーザーがフォローしているユーザー一覧を表示
  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(6).reverse_order  # フォローしているユーザーの一覧を取得
  end
  
  # ユーザーをフォローしているユーザー一覧を表示
  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(6).reverse_order  # フォロワーの一覧を取得
  end

  private
  # Strong Parameters: ユーザー情報のパラメータを制限
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end
