require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "micropost interface" do
    get new_micropost_path
    # assert_select 'div.pagination'

    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "", title: "title" } }
    end
    assert_select 'div#error_explanation'
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "content", title: "" } }
    end
    assert_select 'div#error_explanation'

    
 
       
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "micropost sidebar count" do
    get new_micropost_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get new_micropost_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost", title: "title")
    get new_micropost_path
    assert_match "#{other_user.microposts.count} micropost", response.body
  end

 # 有効な送信
  test "micropost.size is 100 over" do
    # 100文字以上の文章を投稿する
    content = "This micropost really ties the room together. 
               This micropost really ties the room together.
               This micropost really ties the room together."
    title = "title"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, title: title } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content.truncate(100), response.body
    assert_select 'a', "続きを見る"
  end

  test "micropost.size is 100 below" do
    # 100文字以下の文章を投稿する
    content = "This micropost really ties the room together."
    title = "title"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, title: title } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content.truncate(100), response.body
    assert_select 'a', "続きを見る", count: 0
  end

end