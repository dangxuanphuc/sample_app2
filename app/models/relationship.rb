class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name, counter_cache: :followers_count
  belongs_to :followed, class_name: User.name, counter_cache: :followings_count

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
