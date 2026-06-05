class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :name, presence: true
  validate :avatar_is_supported_image

  private

  def avatar_is_supported_image
    return unless avatar.attached?

    unless avatar.blob.content_type.in?(%w[image/jpeg image/png image/webp image/gif])
      errors.add(:avatar, "must be a JPG, PNG, WEBP, or GIF image")
    end

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "must be smaller than 5MB")
    end
  end
end
