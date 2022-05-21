class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id    # 高速化
    add_index :relationships, :followed_id    # 高速化
    add_index :relationships, [:follower_id, :followed_id], unique: true    # 一意性
  end
end
