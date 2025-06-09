class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order(:id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "ユーザーを作成しました"
    else
      flash.now[:alert] = "作成に失敗しました"
      render :new
    end
  end

  def show
  end

  def edit
    @field = params[:field]
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザー情報を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザーを削除しました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :user_id, :email, :password, :password_confirmation, :role)
  end

  def admin_only
    redirect_to root_path, alert: "アクセス権限がありません" unless current_user&.admin?
  end
end
