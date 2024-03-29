class UsersController < ApplicationController
	
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new    
		@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Alpha Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    set_user
  end
    
  def update
    set_user
    if @user.update(user_params)
      flash[:success] = "Account updated successfuly" 
      redirect_to articles_path
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def show
    set_user
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and user's articles deleted"
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? && !current_user.admin? 
      flash[:danger] = "Only admin users can perform that action"
      redirect_to root_path
    end
  end

end
