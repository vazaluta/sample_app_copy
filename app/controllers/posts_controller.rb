class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    posts = Post.includes(:favorite_users).sort {|a,b| b.favorite_users.size <=> a.favorite_users.size}
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = current_user.comments.new
    @favorite_users = @post.favorite_users
    # @favorite = current_user.favorites.new
    # @favorited = current_user.favorites.find_by(post_id: @post.id)

  end

  def new
    @post = current_user.posts.build
  end

  def create 
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'posts/new'
      # redirect_to root_url
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Post updated"
      redirect_to @post
    else
      render 'edit'
    end
  end

  
  # DELETE /posts/:id
  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    # 一個前のページに戻す(つまり画面を変えないで削除する)
    # redirect_back(fallback_location: root_url)
    # これでもOK=> redirect_to request.referrer || root_url
    redirect_to root_url
    # 一つ前のページは/posts/のため、
    # そこにGETリクエストを送っても、そんなパスはない
  end
  
  private

    # strong parameter
    def post_params
      self.params.require(:post).permit(:content, :title)
      # params[:post][:content/:title] 
      # => post のデータの集合を渡すんだけど、其の中のcontentとtitleのみに限定して渡しますよ
    end
    
    # current_userがdeleteしようとしている投稿を保有していないならrootへ飛ぶ
    def correct_user
          @post = current_user.posts.find_by(id: params[:id])
          redirect_to root_url if @post.nil?
    end
end