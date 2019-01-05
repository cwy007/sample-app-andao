class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # 要求先登录
  before_action :correct_user, only: [:edit, :update] # 只允许用户修改自己的信息
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user) # 用户注册成功后，将用户直接登录
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user # 将请求重定向到详情页面
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation) # admin 是允许通过 request 修改的属性
    end

    def logged_in_user # 过滤方法，要求用户继续操作前先登录
      unless logged_in?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end

    def correct_user # 对的用户
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) # id 所对应的用户，与当前用户 current_user 不一致时，请求会被重定向回 root_url
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
