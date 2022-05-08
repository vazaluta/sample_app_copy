module SessionsHelper
  
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    # session...Hashのように扱えるメソッド
    #           :user_idにuserのidを格納（一時coockiesに保存）    
  end
  
  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember #'models/user'より
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 現在ログイン中のユーザーを返す（いる場合）
  # modelにアクセスする回数を減らす目的
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])    #true or false
      @current_user ||= User.find_by(id: session[:user_id])
      # 以下と同義↓↓↓
      # if @current_user.nil?
      #   @current_user = User.find_by(id: session[:user_id])
      # else
      #   @current_user
      # end
    elsif (user_id = cookies.signed[:user_id])    #true or false　復号化
      # raise       # テストがパスすれば、この部分がテストされていないことがわかる
      user = User.find_by(id: user_id)            # 検索
      # nilguard => トークンとデータベースの照合
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user    # nil guard
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?    # hedder/controllerで使用
    !current_user.nil?
  end
  
     # 永続的セッションを破棄する
  def forget(user)
    user.forget   # user.rb より
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?   
    # updateアクションでsession切れ=> login => ここで表示したいのはeditフォーム
    # =>なのでupdate の時はURLを保存しなくて良い
  end
end
