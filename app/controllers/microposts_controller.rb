class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    microposts = Micropost.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    @microposts = Kaminari.paginate_array(microposts).page(params[:page]).per(10)
  end

  def show
    @micropost = Micropost.find(params[:id])
  end

  def new
    @micropost = current_user.microposts.build
  end

  def create 
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'microposts/new'
      # redirect_to root_url
    end
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update(micropost_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Post updated"
      redirect_to @micropost
    else
      render 'edit'
    end
  end

  
  # DELETE /microposts/:id
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # 一個前のページに戻す(つまり画面を変えないで削除する)
    # redirect_back(fallback_location: root_url)
    # これでもOK=> redirect_to request.referrer || root_url
    redirect_to root_url
    # 一つ前のページは/microposts/のため、
    # そこにGETリクエストを送っても、そんなパスはない
  end
  
  private

    # strong parameter
    def micropost_params
      self.params.require(:micropost).permit(:content, :title)
      # params[:micropost][:content/:title] 
      # => micropost のデータの集合を渡すんだけど、其の中のcontentとtitleのみに限定して渡しますよ
    end
    
    # current_userがdeleteしようとしている投稿を保有していないならrootへ飛ぶ
    def correct_user
          @micropost = current_user.microposts.find_by(id: params[:id])
          redirect_to root_url if @micropost.nil?
    end
end