class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :children, class_name: 'Folder', foreign_key: 'parent_id', dependent: :destroy
  has_many :nodes, dependent: :destroy

  has_many :mount_targets, class_name: "Mount", foreign_key: 'target_id'

  # other folders that are 'mounted' here
  has_many :overlays, through: :mount_targets, source: 'source'

  # remote folders
  has_many :bridges, class_name: "RemoteMount", foreign_key: 'target_id'

  before_create :assign_owner_from_parent

  def virtual_children
    virtual_subfolders = overlays.flat_map(&:children)
    names = virtual_subfolders.map(&:title).uniq - children.map(&:title).uniq

    names.map do |virtual_folder_name|
      VirtualFolder.new(title: virtual_folder_name, parent_path: self.path)
    end
  end

  def virtual_nodes
    vnodes = overlays.flat_map(&:nodes)
    names = vnodes.map(&:title).uniq - nodes.map(&:title).uniq

    names.map do |virtual_node_name|
      VirtualNode.new(title: virtual_node_name, parent_path: self.path)
    end
  end

  def remote_children
    rkids = bridges.flat_map(&:children) #.uniq(&:title)
    names = rkids.map(&:title).uniq # - nodes.map(&:title).uniq - virtual

    names.map do |remote_child_name|
      VirtualFolder.new(title: remote_child_name, parent_path: self.path, remote: true)
    end
  end

  def remote_nodes
    rnodes = bridges.flat_map(&:nodes)
    names = rnodes.map(&:title).uniq

    names.map do |remote_node_name|
      VirtualNode.new(title: remote_node_name, parent_path: self.path, remote: true)
    end
  end

  def tags
    (nodes.flat_map(&:tags) + children.flat_map(&:tags)).uniq
  end

  def path
    if parent
      parent.path + title + '/'
    else
      '/'
    end
  end

  def empty?
    !(children.any? || nodes.any? || virtual_children.any? || virtual_nodes.any?)
  end

  def self.root
    Folder.find_by(parent: nil, title: "root")
  end

  def self.usr
    Folder.find_by(parent: root, title: 'usr')
  end

  def self.home_for(user)
    Folder.find_or_create_by(parent: usr, title: user.name, user: user)
  end

  def self.minutes_for(user)
    Folder.find_or_create_by(parent: home_for(user), title: "minutes", user: user)
  end

  private
  def assign_owner_from_parent
    unless self.user.present?
      self.user = self.parent.user
    end
  end
end
