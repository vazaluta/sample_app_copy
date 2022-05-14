class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]   # 期限切れか?
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest   # user.rb
      @user.send_password_reset_email   # user.rb
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  
  # GET /password_resets/:id/edit
  def edit
  end
  
  # PATCH /password_resets/:id
  def update
    if params[:user][:password].empty?                  # 空文字か？
      @user.errors.add(:password, :blank)               # validation はallow_nilでPassするので手作業でエラーを起こす。引数に属性とメッセージを渡す。
      render 'edit'
    elsif @user.update(user_params)                     # 正しいなら更新する　引数は下記のStrong Parameter
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] =  "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # 無効なパスワードである
    end
  end
  
  private
    
    def user_params
      # user tableの中の~のみ送信を許可する
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ
    # account_activation_controllerの書き換え
      def get_user
        @user = User.find_by(email: params[:email])   # edit.html.erb で:[mail]属性を格納してる
      end
  
      # 正しいユーザーかどうか確認する
      def valid_user
        unless (@user && @user.activated? &&
                @user.authenticated?(:reset, params[:id]))
          redirect_to root_url
        end
      end
      
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
