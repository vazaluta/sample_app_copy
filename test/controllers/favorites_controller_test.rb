# require 'test_helper'

# class FavoritesControllerTest < ActionDispatch::IntegrationTest

#   test "should redirect create when not logged in" do
#     assert_no_difference 'Favorite.count' do
#       post post_favorites_path, params: { posts(:one), users(:michael) }
#     end
#     assert_redirected_to login_url
#   end

#   # test "should redirect destroy when not logged in" do
#     assert_no_difference 'Post.count' do
#   #     delete post_path(@post)
#   #   end
#   #   assert_redirected_to login_url
#   # end

#   # test "should redirect destroy for wrong post" do
#   #   log_in_as(users(:michael))
#   #   post = posts(:ants)   # posts.yml から:antsさんの投稿を格納する
#   #   assert_no_difference 'Post.count' do
#   #     delete post_path(post)
#   #   end
#   #   assert_redirected_to root_url
#   # end

#   # test "favorite create should require logged-in user" do
#   #   assert_no_difference 'Favorite.count' do
#   #     post post_favorites_path()
#   #   end
#   #   assert_redirected_to post_path(self.id)
#   # end

# #   test "favorite destroy should require logged-in user" do
# #     assert_no_difference 'Favorite.count' do
# #       delete post_favorite_path(favorites(:one))
# #     end
# #     assert_redirected_to post_path(self.id)
# #   end
# end

