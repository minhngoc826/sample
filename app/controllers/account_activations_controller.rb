class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by_email params[:email]
    if user && !user.activated? && user.autheticate?(:activation, params[:id])
      user.activate
      log_in user
      flash[:info] = t ".activated"
      redirect_to user
    else
      flash[:danger] = t ".invalid"
      redirect_to root_url
    end
  end
end
