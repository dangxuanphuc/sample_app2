class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :user_id, presence: true

  scope :desc, ->{order created_at: :desc}
  scope :feed, ->(following_ids, id){
    where("user_id IN (?)
      OR user_id = (?)", following_ids, id)
  }

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost_max_length}
  validate  :picture_size

  private

  def picture_size
    if picture.size > Settings.picture_size.megabytes
      errors.add :picture, "should be less than 5MB"
    end
  end
end
