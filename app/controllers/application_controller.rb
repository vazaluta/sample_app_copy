class ApplicationController < ActionController::Base
  #　複数のコントローラーでセッションメソッドを使用できる
  include SessionsHelper
  
  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end