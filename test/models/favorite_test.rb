require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  def setup

    @user = users(:michael)
    @micropost = microposts(:orange)
    @favorite = @user.favorites.build(micropost_id: @micropost.id)

    # @favorite = Favorite.new(user_id: users(:michael).id,
    #                     micropost_id: microposts(:orange).id)
  end

  test "should be valid" do
    assert @favorite.valid?
  end

  test "should require a user_id" do
    @favorite.user_id = nil
    assert_not @favorite.valid?
  end

  test "should require a micropost_id" do
    @favorite.micropost_id = nil
    assert_not @favorite.valid?
  end
end
