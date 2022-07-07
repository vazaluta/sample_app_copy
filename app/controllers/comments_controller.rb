class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)  #コメント送信後は、一つ前のページへリダイレクトさせる。
    else
      redirect_back(fallback_location: root_path)  #同上
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.find_by(id: @.id)
    @comment.destroy
    # redirect_to post_path(params[:post_id]) <=Ajaxを使用するためにここを削除
    @favorite_users = @post.favorite_users
  end

  private
    def comment_params
      params.require(:comment).permit(:comment_content, :post_id)  
      #formにてpost_idパラメータを送信して、コメントへpost_idを格納するようにする必要がある。
    end
end
