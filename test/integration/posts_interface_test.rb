require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "post invalid post " do
    get new_post_path
    # assert_select 'div.pagination'
    # 無効な送信
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "", title: "title" } }
    end
    assert_select 'div#error_explanation'
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "content", title: "" } }
    end
    assert_select 'div#error_explanation'
  end
  
  test "post sidebar count" do
    get new_post_path
    assert_match "#{@user.posts.count} posts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get new_post_path
    assert_match "0 posts", response.body
    other_user.posts.create!(content: "A post", title: "title")
    get new_post_path
    assert_match "#{other_user.posts.count} post", response.body
  end

 # 有効な送信
  test "post.size is 100 over | post delete" do
    # 100文字以上の文章を投稿する
    content = "This post really ties the room together. 
               This post really ties the room together.
               This post really ties the room together."
    title = "title"
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content, title: title } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content.truncate(100), response.body
    assert_select 'a', text: "続きを見る"
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "post.size is 100 below" do
    # 100文字以下の文章を投稿する
    content = "This post really ties the room together."
    title = "title"
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content, title: title } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content.truncate(100), response.body
    assert_select 'a', text: "続きを見る", count: 0
  end

end