# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Like.destroy_all
Comment.destroy_all
Post.destroy_all
FollowRequest.destroy_all
Profile.destroy_all
User.destroy_all

users = 5.times.map do
  user = User.create!(
    email: Faker::Internet.email,
    password: "password"
  )

  user.profile.update!(
    name: Faker::Name.name,
    bio: Faker::Lorem.sentence
  )

  user
end

users.each do |user|
  3.times do
    user.posts.create!(
      content: Faker::Lorem.paragraph
    )
  end
end

Post.all.each do |post|
  users.sample(2).each do |user|
    post.comments.create!(
      user: user,
      content: Faker::Lorem.sentence
    )

    post.likes.find_or_create_by!(
      user: user
    )
  end
end

users[0].sent_follow_requests.create!(
  receiver: users[1],
  status: "accepted"
)

users[0].sent_follow_requests.create!(
  receiver: users[2],
  status: "accepted"
)