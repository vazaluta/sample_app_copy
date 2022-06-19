class User < ApplicationRecord
  has_many :favorites,  dependent: :destroy
  has_many :microposts, dependent: :destroy
  # => micropost_id <-> user_idaaaaaaa
  # => Default: class_name: "Micropost" 問題なし
  # => Default: foreign_key: micropost_id  問題なし
  # => "#{Model Name}s"
  has_many :active_relationships, class_name:  "Relationship",
                                 foreign_key:  "follower_id", # 自分のid
                                   dependent:   :destroy  # 自分が削除されたら相手のfollowerが一人減るよ 
  # => Default: class_name: "active_relationship" 問題あり
  # => Default: foreign_key: actiove_relationship_id  問題あり
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key:  "followed_id", # 自分のid
                                    dependent:  :destroy
                                    # realationship tabaleのfollowed_id culum
  has_many :following, through: :active_relationships,
                        source: :followed # method
  # => following methodを使うことで、下記と同じことができる
  # => user.active_relationships.map(&:followed)
  has_many :followers, through: :passive_relationships,
                        source: :follower # method
  
  # favoriteした投稿のデータの塊を表示。throughはメソッド名、つまりfavoriteではない
  has_many :favorited_microposts,  through: :favorites,
                                   source: :micropost
  
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  
  validates(:name,  presence: true, length: { maximum: 50  })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true)
                    
  has_secure_password                   # DBにレコードが生成された時だけ存在性のvalidationをおこなう
  validates :password, presence: true,  # 値がnilや空文字でないことを確認
                         length: { minimum: 6 },
                      allow_nil: true   # 対象がnilの場合はvalidationをskip
                                        # =>値が空文字(" "*6など)の場合はvalidationにひっかかる

  # 渡された文字列のハッシュ値を返す Bcryptの文法
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token  # setter
    # remember_digestカラムに、remember_token（記憶トークン）をハッシュ化した値を、
    # 記録させる
    # :remember_digest => culum
    #  remember_token  => attribute 
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?    # 実行しない
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?    # 実行しない
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget    # 引数なし　'sessions_helper'にて使用
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    update_columns(activated:  true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now   # user_mailer.erb
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  # user.idに合致する投稿をパッケージ化する
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
                     # =>サブセレクト
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: self.id)
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                 following_ids: following_ids, user_id: self.id)
    # =>問い合わせ２回
    # => following_idsとself.idの投稿の和集合を取得
    # => following_ids == following.map(&:id) # followしている人のidを取得
    # Micropost.where("user_id = ?", self.id) 
    # => SQL文に変数を代入する場合は常にescapeする
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    self.following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    self.following.include?(other_user)
  end

  # 引数の投稿をすでにいいねしているか？
  def already_favorited?(micropost)
    self.favorites.exists?(micropost_id: micropost.id)
  end

  # ユーザーをいいねする
  def favorite(micropost)
    self.favorited_microposts << micropost
    # => self.favorites.map(&:micropost)
  end

  # ユーザーのいいねをはずす
  def unfavorite(micropost)
    self.favorites.find_by(micropost_id: micropost.id).destroy
  end

  def favorite_feed
    favorited_microposts_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
                     # =>サブセレクト
    Favorite.where("user_id IN (#{favorited_microposts_ids})
                     OR user_id = :user_id", user_id: self.id)
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id", 
    #                 following_ids: following_ids, user_id: self.id)
    # =>問い合わせ２回
    # => following_idsとself.idの投稿の和集合を取得
    # => following_ids == following.map(&:id) # followしている人のidを取得
    # Micropost.where("user_id = ?", self.id) 
    # => SQL文に変数を代入する場合は常にescapeする
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end