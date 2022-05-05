class ApplicationController < ActionController::Base
  #　複数のコントローラーでセッションメソッドを使用できる
  include SessionsHelper
end