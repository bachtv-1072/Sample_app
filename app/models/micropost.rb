class Micropost < ApplicationRecord
  MICROPOSTS_PARAMS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  validates :content, presence: true, length: { maximum: Settings.content }
  validates :image, content_type: { in: Settings.image.file_name, message: I18n.t("micropost.image.message") },
    size: { less_than: Settings.panigate.users.megabytes, message: I18n.t("micropost.image.size") }

  scope :order_post, -> { order created_at: :desc }
  scope :feed, ->id { where user_id: id }

  delegate :name, to: :user, prefix: true
end
