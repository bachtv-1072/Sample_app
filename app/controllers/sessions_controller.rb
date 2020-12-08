class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_activated user
    else
      flash[:danger] = t "login.message.danger"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_activated user
    if user.activated?
      log_in user
      check_remember params[:session][:remember_me], user
      redirect_back_or user
    else
      flash[:warning] = t "login.message.dangder"
      redirect_to root_url
    end
  end

  def check_remember remember_me, user
    remember_me == Settings.session.remember ? remember(user) : forget(user)
  end
end
