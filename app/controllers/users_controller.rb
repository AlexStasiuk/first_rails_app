class UsersController < ApplicationController
  before_action :set_user , only: [:edit, :destroy, :update, :show]
  before_action :require_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  def new 
    @user = User.new()
  end

  def create
    #byebug
    @user = User.new(user_params)
    if @user.save
        flash[:notice] = "Welcome #{@user.username}!"
        redirect_to @user
    else
        render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update 
    if @user.update(user_params)
        flash[:notice] = "You successfuly updated information about your account"
        redirect_to @user
    else
        render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    username = @user.username
    if @user.destroy
      session[:user_id] = nil
      flash[:notice] = "#{username} you successfully delete your profile"
      redirect_to login_path
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:username,:email,:password)
  end
  
  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user
      flash[:alert] = "You can only edit your own account"
      redirect_to current_user
    end
  end
end