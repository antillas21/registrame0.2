class Admin::UsersController < Admin::BaseController
  before_filter :find_user, :only => [:edit, :update, :destroy]
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_users_path, :notice => "User has been created."
    else
      flash[:error] = "User has not been created."
      render 'new'
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, :notice => "User has been updated."
    else
      flash[:error] = "User could not be updated."
      render 'edit'
    end
  end

  def destroy
    if @user.admin?
      flash[:error] = "You cannot delete yourself!"
    else
      @user.destroy
      flash[:notice] = "User has been deleted."
    end
    redirect_to admin_users_path
  end

  private
    def find_user
      @user = User.find(params[:id])
    end
end
