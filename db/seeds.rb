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
  content = Faker::Lorem.sentence(word_count: 5)    # 適当な５wordsを作成
  users.each { |user| user.microposts.create!(content: content) }
end
