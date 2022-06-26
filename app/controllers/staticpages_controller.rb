class StaticpagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      feed_items = current_user.feed
      @feed_items = Kaminari.paginate_array(feed_items).page(params[:page]).per(10)
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
