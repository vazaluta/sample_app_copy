class Favorite < ApplicationRecord
  # レコード一つに対してuser/postはそれぞれ一つずつ関連付けられる
  # userメソッド:@favorite.user=>@favorite Tableの中にuserが含まれる要素をハッシュにする 
  belongs_to :user
  # postメソッド: @favorite.post=>
  belongs_to :post

  validates :user_id,      presence: true
end
