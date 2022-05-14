class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]   # log_inしていることを保証する
  before_action :correct_user,   only: [:edit, :update]   # log_inしていることが前提で書かれている
  before_action :admin_user,     only: :destroy
  
  # GET /users
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    # debugger
  end
  
  def new
    @user = User.new
    # debugger
  end
  
  # POST /users (+ params)
  def create
    # (user + given params).save
    # User.create(params[:user])
    # => name, email, pass/confirmation
    @user = User.new(user_params)
    if @user.save
      # Success (valid params)
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
      #Failure
    end
  end
  
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])  
    # => app/views/users/edit.html.erb
  end
  
  # PATCH /users/:id
  def update
    @user = User.find(params[:id])  
    if @user.update(user_params)   
    # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # @users.errors <== ここにデータが入っている
      render 'edit'
    end
  end
  
  # DELETE /user/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private 
  
    def user_params
        params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end
    
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location    # 行こうとしていたurlを一時的に覚えておく(sessions_helper)
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
