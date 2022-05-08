class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false   
    # defaultを決めないとデフォルトではnil
    # true か falseでadminを扱いたい(ifなどで条件を限定できる)
  end
end
