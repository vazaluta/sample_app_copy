class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User" 
    # => methodを定義している。
    # => relationship.follower => follower_idからuser情報を引っ張る 
    # => follower_id <-> user_id
    # => Default: class_name: "Follower" 問題あり
    # => Default: foreign_key: Follower_id 問題あり
    #                         <class Name>_id 
  belongs_to :followed, class_name: "User" # => methodを定義している
    # => followed_id <-> user_id
    # => Default: class_name: "Followed" 問題あり
    # => Default: foreign_key: Followed_id  問題あり
    validates :follower_id, presence: true
    validates :followed_id, presence: true
end