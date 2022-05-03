class UsersController < ApplicationController
  
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
      # GET "/users/#{@user.id}"  <= 結論
      flash[:success] = "Welcome to the Sample App!"    # hashのように使えるメソッド、一時的に表示
      redirect_to @user
      # redirect_to user_path(@user)
      # => redirect_to user_path(@user.id)
      # => redirect_to user_path(1)
      # => /user/1  
    else
      render 'new'
      #Failure
    end
  end
  
  private 
  
    def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end
end
