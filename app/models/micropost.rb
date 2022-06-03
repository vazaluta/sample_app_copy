class Micropost < ApplicationRecord
  belongs_to :user
  # => user_id <-> micropost_id
  # => Default: foreign_key: user_id  問題なし
  
  default_scope -> { self.order(created_at: :desc) }    # order :順序
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 5000 }
end
