require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  def setup

    @user = users(:michael)
    @post = posts(:orange)
    @favorite = @user.favorites.build(post_id: @post.id)

    # @favorite = Favorite.new(user_id: users(:michael).id,
    #                     post_id: posts(:orange).id)
  end

  test "should be valid" do
    assert @favorite.valid?
  end

  test "should require a user_id" do
    @favorite.user_id = nil
    assert_not @favorite.valid?
  end

  test "should require a post_id" do
    @favorite.post_id = nil
    assert_not @favorite.valid?
  end
end
