require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper   # full_title methodを使用するため

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'section>img.gravatar'                           # h1 tagの内側にあるgravatar classのimg tag
    assert_match @user.posts.count.to_s, response.body   # body tagだけではなく、page全体
    assert_select 'div.pagination', count: 1
    @user.posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
    assert_select 'strong#following', @user.following.count.to_s
    assert_select 'strong#followers', @user.followers.count.to_s
  end
end
