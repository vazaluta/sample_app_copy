require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @not_activated_user = users(:not_activated_user)
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'nav.pagination', count: 2
    users = User.where(activated: true).includes(:followers).sort {|a,b| b.followers.size <=> a.followers.size}
    first_page_of_users = Kaminari.paginate_array(users).page(1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert         user.activated
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
