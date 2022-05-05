module SessionsHelper
  
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    # session...Hashのように扱えるメソッド
    #           :user_idにuserのidを格納（一時coockiesに保存）    
  end
  
  # 現在ログイン中のユーザーを返す（いる場合）
  # modelにアクセスする回数を減らす目的
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
      # 以下と同義↓↓↓
      # if @current_user.nil?
      #   @current_user = User.find_by(id: session[:user_id])
      # else
      #   @current_user
      # end
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
