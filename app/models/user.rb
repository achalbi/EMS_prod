# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :user_groups, dependent: :destroy
  has_many :groups, :through => :user_groups

  has_many :events, dependent: :destroy
  has_many :event_editor_users, dependent: :destroy
  has_many :events_editor, class_name: "Event", :through => :event_editor_users

  has_many :event_invited_users, dependent: :destroy
  has_many :events_invited, class_name: "Event", :through => :event_invited_users
  has_many :events, foreign_key: "creator", dependent: :destroy

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  #before_create { generate_token(:remember_token) }

  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!(:validate => false)
  UserMailer.password_reset(self).deliver
end

def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end

def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def self.search(search, exclude_user)
    if search  
      if exclude_user.nil?
        where('name LIKE ?', "%#{search}%" )  
      else
        where('name LIKE ? AND id NOT IN (?)', "%#{search}%" , exclude_user)  
      end
    else  
      scoped  
    end  
  end 

  private
  def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end


end
