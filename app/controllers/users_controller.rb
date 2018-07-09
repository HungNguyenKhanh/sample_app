class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :get_user, only: [:show, :edit, :update, :destroy, :following,
    :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.profile.paginate(per_page: Settings.users_page.SIZE,
      page: params[:page])
  end

  def show
    @microposts = @user.microposts.paginate(
      per_page: Settings.micropost.page.SIZE,
      page: params[:page]
    )
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".chk_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".deleted"
    redirect_to users_url
  end

  def following
    @title = t "users.relation.following"
    @users = @user.following.paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = t "users.relation.followers"
    @users = @user.followers.paginate(page: params[:page])
    render :show_follow
  end

  private

  def get_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".not_exist"
    redirect_to root_path
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
