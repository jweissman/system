class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :children, class_name: 'Folder', foreign_key: 'parent_id', dependent: :destroy
  has_many :nodes, dependent: :destroy

  has_many :mounts, foreign_key: 'target_id'
  has_many :symlinks, foreign_key: 'target_id'

  # other folders that are 'mounted' here
  has_many :overlays, through: :mounts, source: 'source'
  # has_many :symbolic_overlays #source_paths
  # has_many :symbolic_overlay_s, through: :symlinks, source: 'source_path'

  def symbolic_paths
    symlinks.map(&:source_path)
  end

  def symbolic_overlays
    symbolic_paths.map { |p| Path.dereference(p) }
  end

  # remote folders
  has_many :bridges, class_name: "RemoteMount", foreign_key: 'target_id'

  before_create :assign_owner_from_parent

  def virtual_children
    virtual_subfolders = overlays.flat_map(&:children) # + symbolic_overlays.flat_map(&:children) # + symbolic_overlays.flat_map(&:remote_children)
    names = virtual_subfolders.map(&:title).uniq - children.map(&:title).uniq

    names.map do |virtual_folder_name|
      VirtualFolder.new(title: virtual_folder_name, parent_path: self.path)
    end
  end

  def virtual_nodes
    vnodes = overlays.flat_map(&:nodes) # + overlays.flat_map(&:virtual_nodes) # + symbolic_overlays.flat_map(&:nodes) # + symbolic_overlays.flat_map(&:remote_nodes)
    names = vnodes.map(&:title).uniq - nodes.map(&:title).uniq

    names.map do |virtual_node_name|
      VirtualNode.new(title: virtual_node_name, parent_path: self.path)
    end
  end

  def remote_children
    rkids = bridges.flat_map(&:children) # + symbolic_overlays.flat_map(&:remote_children)
    names = rkids.map(&:title).uniq

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

  def local_symbolic_children
    skids = symbolic_overlays.flat_map(&:children) + symbolic_overlays.flat_map(&:virtual_children) #+ symbolic_overlays.flat_map(&:remote_children)
    names = skids.map(&:title).uniq

    names.map do |sym_child_name|
      VirtualFolder.new(title: sym_child_name, parent_path: self.path, symbolic: true)
    end
  end

  def remote_symbolic_children
    skids = symbolic_overlays.flat_map(&:remote_children)
    names = skids.map(&:title).uniq

    names.map do |sym_child_name|
      VirtualFolder.new(title: sym_child_name, parent_path: self.path, symbolic: true, remote: true)
    end
  end

  def symbolic_children
    local_symbolic_children + remote_symbolic_children
  end

  def local_symbolic_nodes
    snodes = symbolic_overlays.flat_map(&:nodes) + symbolic_overlays.flat_map(&:virtual_nodes) # + symbolic_overlays.flat_map(&:remote_nodes)
    names = snodes.map(&:title).uniq

    names.map do |sym_node_name|
      VirtualNode.new(title: sym_node_name, parent_path: self.path, symbolic: true)
    end
  end

  def remote_symbolic_nodes
    snodes = symbolic_overlays.flat_map(&:remote_nodes)
    names = snodes.map(&:title).uniq

    names.map do |sym_node_name|
      VirtualNode.new(title: sym_node_name, parent_path: self.path, symbolic: true, remote: true)
    end
  end

  def symbolic_nodes
    local_symbolic_nodes + remote_symbolic_nodes
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

  def themed?
    active_theme.present?
    # theme.present? || (parent && parent.themed?
  end

  def active_theme
    theme || (parent && parent.active_theme)
  end

  def theme_root
    if parent && parent.themed?
      parent.theme_root
    else
      self
    end
  end

  def descendants(depth=4)
    if depth < 0
      []
    else
      (nodes + virtual_nodes + remote_nodes + symbolic_nodes) +
        (children.flat_map { |child| child.descendants(depth-1)}) +
        virtual_children.flat_map { |vchild| vchild.descendants(depth-1) } +
        remote_children.flat_map { |rchild| rchild.descendants(depth-1) } +
        symbolic_children.flat_map { |schild| schild.descendants(depth-1) }
    end
  end

  def remote?
    false
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
