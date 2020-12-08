class UsersController < ApplicationController
  before_action :find_user, only: :show

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "signup.message.success"
      redirect_to @user
    else
      flash[:danger] = t "signup.message.fail"
      render :new
    end
  end

  private

  def find_user
    @user = User.find params[:id]
    return if @user

    flash[:danger] = t "signup.message.login"
    redirect_to @user
  end

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

end
