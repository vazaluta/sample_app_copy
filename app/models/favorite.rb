class Favorite < ApplicationRecord
  # レコード一つに対してuser/micropostはそれぞれ一つずつ関連付けられる
  # userメソッド:@favorite.user=>@favorite Tableの中にuserが含まれる要素をハッシュにする 
  belongs_to :user
  # micropostメソッド: @favorite.micropost=>
  belongs_to :micropost
end
