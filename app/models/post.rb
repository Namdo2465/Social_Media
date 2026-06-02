class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
