class RelationshipsController < ApplicationController
  before_action :logged_in_user   # => Application_Controller
  
  # POST /realationships
  def create
    @user = User.find(params[:followed_id])  # hidden_fieldに入っている情報
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js # XHLリクエストが来たら、特定のjsを反応させる
      # => default: app/views/relationships/create.js.erb
    end
  end
  
  # DELETE /relationships/:id
  def destroy
    @user = Relationship.find(params[:id]).followed  # relationshipsのid 
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      # => default: app/views/relationships/destroy.js.erb
    end
  end
end
