class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "New account created successfully"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    @user_todos = @user.todos
  end

  def edit

  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was successfully updated"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "This user and their todos have been deleted"
    redirect_to users_path
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :admin
      )
    end

    def require_same_user
      if current_user != @todo.user && !current_user.admin?
        flash[:danger] = "You can only edit your profile"
        redirect_to users_path
      end
    end

    def require_admin
      if signed_in? && !current_user.admin?
        flash[:danger] = "Only admins can perform that action"
      end
    end
end