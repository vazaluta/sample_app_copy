class FavoritesController < ApplicationController
  def show
    @post = Post.find(params[:post_id])
    @favorite_users = @post.favorite_users
  end
  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.create(post_id: @post.id)
    favorite.save
    # binding.pry
    # redirect_to post_path(params[:post_id])  <=Ajaxを使用するためにここを削除
    @favorite_users = @post.favorite_users
    respond_to do |format|
      format.html { redirect_to @post }
      format.js # XHLリクエストが来たら、特定のjsを反応させる
      # => default: app/views/favorites/create.js.erb
    end
  end 

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
    # redirect_to post_path(params[:post_id]) <=Ajaxを使用するためにここを削除
    @favorite_users = @post.favorite_users
    respond_to do |format|
      format.html { redirect_to @post }
      format.js 
      # => default: app/views/favorites/destroy.js.erb
    end
  end
end
