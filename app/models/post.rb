class Post < ApplicationRecord
  belongs_to :user
  # => user_id <-> post_id
  # => Default: foreign_key: user_id  問題なし

  # favoritesメソッド: いいねをした人の
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  # => @post.favorites.map(&:user)

  has_many :comments, dependent: :destroy
  
  default_scope -> { self.order(created_at: :desc) }    # order :順序
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 5000 }
  validates :title, presence: true, length: { maximum: 50 }

  # favorite Tableのuser.idに一致するレコードを検索し、それが存在すればtrue
  def favorited?(user)
    self.favorites.where(user_id: user.id).exists?
  end
 #exits いる？　likesampleでは下記で定義している
 # /Users/masatosawada/environment/like_sample/app/models/user.rb
#  def already_liked?(post)
#   self.likes.exists?(post_id: post.id)
#  end
# ↓
# user.rbに定義してみる


end
