class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'staticpages/home'
      # redirect_to root_url
    end
  end
  
  # DELETE /microposts/:id
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # 一個前のページに戻す(つまり画面を変えないで削除する)
    redirect_back(fallback_location: root_url)
    # これでもOK=> redirect_to request.referrer || root_url
    #         ? =>  redirect_to root_url

  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
    
    # current_userがdeleteしようとしている投稿を保有していないならrootへ飛ぶ
    def correct_user
          @micropost = current_user.microposts.find_by(id: params[:id])
          redirect_to root_url if @micropost.nil?
    end
end