# require 'test_helper'

# class FavoritesControllerTest < ActionDispatch::IntegrationTest

#   test "should redirect create when not logged in" do
#     assert_no_difference 'Favorite.count' do
#       post micropost_favorites_path, params: { microposts(:one), users(:michael) }
#     end
#     assert_redirected_to login_url
#   end

#   # test "should redirect destroy when not logged in" do
#     assert_no_difference 'Micropost.count' do
#   #     delete micropost_path(@micropost)
#   #   end
#   #   assert_redirected_to login_url
#   # end

#   # test "should redirect destroy for wrong micropost" do
#   #   log_in_as(users(:michael))
#   #   micropost = microposts(:ants)   # microposts.yml から:antsさんの投稿を格納する
#   #   assert_no_difference 'Micropost.count' do
#   #     delete micropost_path(micropost)
#   #   end
#   #   assert_redirected_to root_url
#   # end

#   # test "favorite create should require logged-in user" do
#   #   assert_no_difference 'Favorite.count' do
#   #     post micropost_favorites_path()
#   #   end
#   #   assert_redirected_to micropost_path(self.id)
#   # end

# #   test "favorite destroy should require logged-in user" do
# #     assert_no_difference 'Favorite.count' do
# #       delete micropost_favorite_path(favorites(:one))
# #     end
# #     assert_redirected_to micropost_path(self.id)
# #   end
# end

