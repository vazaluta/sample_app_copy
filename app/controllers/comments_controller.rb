class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)  #コメント送信後は、一つ前のページへリダイレクトさせる。
    else
      redirect_back(fallback_location: root_path)  #同上
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Comment updated"
      redirect_to @post
    else
      flash[:danger] = "Comment failed"
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.find_by(post_id: @post.id)
    @comment.destroy
    redirect_to post_path(params[:post_id])
  end

  private
    def comment_params
     #params.require(:comment).permit(:comment_content, :post_id)  
      params.require(:comment).permit(:comment_content).merge(post_id: params[:post_id])
      #formにてpost_idパラメータを送信して、コメントへpost_idを格納するようにする必要がある。
    end
end
