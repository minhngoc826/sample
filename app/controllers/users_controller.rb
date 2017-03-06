class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :create, :new]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate page: params[:page]
  end

  def show
    @user = User.find_by id: params[:id]

    if @user.nil?
      render file: "public/404.html", layout: false
    else
      @microposts = @user.microposts.paginate page: params[:page]
      @micropost = @user.microposts.build if logged_in?
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:infor] = t ".check_email"
      log_in @user
      redirect_to @user
    else
      flash[:danger] = t ".signup_failled"
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update_attributes user_params
      flash[:success] = t ".updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = t ".deleted"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end

    def correct_user
      @user = User.find_by id: params[:id]
      redirect_to root_url unless current_user? @user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
