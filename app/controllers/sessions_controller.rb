class SessionsController < ApplicationController
  def new
    # x @session = Session.new
    # o scope: :session + url: login_path
    # debugger
  end
  
  # POST /login
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
      # user に入力されたemailと一致するuser情報を格納する
      # .downcase=> emailの大文字小文字で別のアドレスとして扱わないように
    if @user&.authenticate(params[:session][:password]) 
      # object を返せばtrueを返す
      if @user.activated?
        log_in(@user)   # sessions_helperより
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)   #　三項演算子
        redirect_back_or(@user)
      #        => forwarding_url or user_url(user)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # alert-danger => 赤色のフラッシュ
      flash.now[:danger] = 'Invalid email/password combination' 
      # flash は一回リクエストは生き残る/ flash.nowは一回リクエストも耐えない
      render 'new' 
      # render リクエストを送らないで、今いるページでnewページを描画する(GET 0回目)
      # redirect_to => GET /users/1 => show template(GET 1回目)
    end
  end
  
  # DELETE /logout
  def destroy
    log_out if logged_in? #sessions_helperより
    redirect_to root_url
  end
end