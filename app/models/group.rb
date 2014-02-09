class Group < ActiveRecord::Base
  belongs_to :User
  belongs_to :photo
  attr_accessible :description, :name, :privacy, :photo_attributes, :user_tokens
  accepts_nested_attributes_for :photo

  attr_reader :user_tokens
  attr_accessor :user_ids
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end

  #has_many :postables, :as => :postable
  has_many :albums, :as => :albumable

  has_many :user_groups, dependent: :destroy
  has_many :users, :through => :user_groups
  has_many :communities, :through => :user_groups

  has_many :groupposts, dependent: :destroy
  has_many :posts, :through => :groupposts

  has_many :event_invited_groups, dependent: :destroy
  has_many :events_invited, class_name: "Event", :through => :event_invited_groups
  
  has_many :event_editor_groups, dependent: :destroy
  has_many :events_editor, class_name: "Event", :through => :event_editor_groups
  has_many :eventdetails, :dependent => :destroy
  has_many :activitydetails, :dependent => :destroy

  validates :User_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def following?(user, group)
    user.user_groups.find_by_group_id(group.id)
  end
  def follow!(user, group_id)
    user.user_groups.create!(group_id: group_id)
  end

  def follow!(user, group_id, invitation, is_admin)
    user.user_groups.create!(group_id: group_id, invitation: invitation, is_admin: is_admin)
  end

  def follow!(user, group_id, invitation, is_admin, community_id)
    user.user_groups.create!(group_id: group_id, invitation: invitation, is_admin: is_admin, community_id: community_id)
  end

  def self.search(search, exclude_group)
    if search  
      if exclude_group.nil?
        where('name LIKE ?', "%#{search}%" )  
      else
        where('name LIKE ? AND id NOT IN (?)', "%#{search}%" , exclude_group)  
      end
    else  
      scoped  
    end  
  end 

end
	