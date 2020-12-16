class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_reset.create.message.flash"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_reset.create.message.danger"
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].blank?
      @user.errors.add :password, t("password_reset.update.message")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "password_reset.create.message.flash"
      redirect_to @user
    else
      flash.now[:danger] = t "password_reset.create.message.danger"
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "signup.message.login"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated? :reset, params[:id]

    flash[:danger] = t "signup.message.login"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "signup.message.login"
    redirect_to new_password_reset_url
  end

end
