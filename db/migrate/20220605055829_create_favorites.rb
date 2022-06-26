class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user,      null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      # null: false => DBの中で、該当idが空の状態で保存できなくする。
      # rails 上で制限をかけるには、validates :user_id, presence: trueとする
      
      t.timestamps
      
      t.index [:user_id, :post_id], unique: true
    end
      # add_index :favorites, [:user_id, :post_id], unique: true    # 一意性
  end
end
