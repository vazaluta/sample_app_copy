require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @post = @user.posts.build(title: "title", content: "Lorem ipsum")
    # このコードは慣習的に正しくない
    # @post = Post.new(content: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end
  
  test "content should be present" do
    @post.content = "   "
    assert_not @post.valid?
  end

  test "content should be at most 140 characters" do
    @post.content = "a" * 5001
    assert_not @post.valid?
  end
  
  test "order should be most recent first" do
    assert_equal posts(:most_recent), Post.first
  end
  
end