class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  Relationship.name,
    foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :messages, dependent: :destroy
  has_many :conversations, foreign_key: :sender_id, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_reader :remember_token
  attr_accessor :activation_token, :reset_token
  before_save :email_downcase
  before_create :create_activation_digest

  validates :name, presence: true,
    length: {maximum: Settings.name_max_length}
  validates :email, presence: true,
    length: {maximum: Settings.email_max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password_min_length}, allow_nil: true

  has_secure_password

  def remember
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"

    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def current_user? user
    user == self
  end

  def forget
    update_attributes remember_digest: nil
  end

  def activate
    update_attributes activated: true
    update_attributes activated_at: Time.zone.now
  end

  def send_activation_email
    email = {user_name: self.name, activation_token: self.activation_token,
      mail: self.email}
    UserMailer.account_activation(email).deliver_later
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token)
    update_attributes reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    pass_reset = {reset_token: self.reset_token, mail: self.email}
    UserMailer.password_reset(pass_reset).deliver_later
  end

  def password_reset_expired?
    reset_sent_at < Settings.hours_max.hours.ago
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def feed
    Micropost.feed following_ids, id
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def email_downcase
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
