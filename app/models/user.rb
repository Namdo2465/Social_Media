class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  after_create :create_default_profile

  has_many :sent_follow_requests,
          class_name: "FollowRequest",
          foreign_key: "sender_id",
          dependent: :destroy

  has_many :received_follow_requests,
          class_name: "FollowRequest",
          foreign_key: "receiver_id",
          dependent: :destroy

  has_many :accepted_sent_follow_requests,
          -> { where(status: "accepted") },
          class_name: "FollowRequest",
          foreign_key: "sender_id"

  has_many :following,
          through: :accepted_sent_follow_requests,
          source: :receiver

  def following?(user)
    following.include?(user)
  end

  def pending_follow_request_to?(user)
    sent_follow_requests.exists?(receiver: user, status: "pending")
  end

  private
  def create_default_profile
    create_profile(name: email.split("@").first)
  end
end
