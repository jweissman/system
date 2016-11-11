class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :children, class_name: 'Folder', foreign_key: 'parent_id'
  has_many :nodes

  # has_many :virtual_mounts, class_name: 'Folder', optional: true

  before_create :assign_owner_from_parent

  def tags
    (nodes.flat_map(&:tags) + children.flat_map(&:tags)).uniq
  end

  def path_components
    if parent
      parent.path_components + [self]
    else
      [self]
    end
  end

  def path
    if parent
      path_components.map(&:title).join('/')
    else
      '/'
    end
  end

  def empty?
    !(children.any? || nodes.any?)
  end

  def self.root
    Folder.find_by(parent: nil, title: "root", user: User.root)
  end

  def self.usr
    Folder.find_by(parent: root, title: 'usr', user: User.root)
  end

  def self.home_for(user)
    Folder.find_or_create_by(parent: usr, title: user.name, user: user)
  end

  private
  def assign_owner_from_parent
    unless self.user.present?
      self.user = self.parent.user
    end
  end
end
