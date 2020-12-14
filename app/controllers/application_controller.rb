class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper

  before_action :set_locale

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "comfirm_login.message"
    redirect_to login_url
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
