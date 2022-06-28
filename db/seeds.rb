# for devloppment environment 

# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",   # 例外処理"!"によって、validationで１００回引っかかるのを防ぐ
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,      # 権限の付与
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  "not_activated_user",   # 例外処理"!"によって、validationで１００回引っかかるのを防ぐ
             email: "not_activated_user@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             activated: false,
             activated_at: Time.zone.now)

User.create!(name:  "sawada masato",   # 例外処理"!"によって、validationで１００回引っかかるのを防ぐ
            email: "vazaluta@gmail.com",
            password:              "foobar",
            password_confirmation: "foobar",
            admin: false,      # 権限の付与
            activated: true,
            activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(word_count: 5)    # 適当な５wordsを作成
  content = Faker::Lorem.sentence(word_count: 200)    # 適当な200wordsを作成
  users.each { |user| user.posts.create!(title: title, content: content) }
end

# 以下のリレーションシップを作成する
users = User.all
first_user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| first_user.follow(followed) }
followers.each { |follower| follower.follow(first_user) }
second_user = users.second
third_user = users.third
second_user.follow(third_user)

# favoriteテーブルに作成
post  = Post.first
first_user.favorite(post)
second_user.favorite(post)
third_user.favorite(post)

# commentテーブルに作成
users = User.order(:created_at).take(6)
10.times do
  comment_content = Faker::Lorem.sentence(word_count: 20)    # 適当な20wordsを作成
  users.each { |user| user.comments.create!(comment_content: comment_content, post_id: post.id) }
end
