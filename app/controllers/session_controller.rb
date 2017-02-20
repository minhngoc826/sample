class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to current_user
    else
      flash[:danger] = t ".invalid"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
