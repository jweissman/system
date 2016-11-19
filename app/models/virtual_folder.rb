# a folder present because of a mount
# there is no distinct database record for it but it needs to be logically distinct and reachable from a path
class VirtualFolder
  include ActiveModel::Model
  include ActiveModel::Serialization
  # extend ActiveModel::Naming

  attr_reader :title, :parent_path

  def initialize(title:, parent_path:, remote:false, symbolic: false)
    @title = title
    @parent_path = parent_path
    @remote = remote
    @symbolic = symbolic
  end

  def remote?
    !!@remote
  end

  def parent
    Path.dereference(@parent_path)
  end

  def user
    parent.user
  end

  def constituents
    @constituents ||=
    (
      base = parent.overlays # + parent.symbolic_overlays
      base += parent.constituents if parent.is_a?(VirtualFolder)
      base.flat_map(&:children).select do |constituent|
        constituent.title == title
      end
    )
  end

  def virtual_children
    return [] if @remote
    kids = constituents.flat_map(&:children) + constituents.flat_map(&:virtual_children)
    vchildren_names = kids.map(&:title).uniq
    vchildren_names.map do |name|
      VirtualFolder.new(title: name, parent_path: path)
    end
  end

  def virtual_nodes
    return [] if @remote
    ns = constituents.flat_map(&:nodes) + constituents.flat_map(&:virtual_nodes)
    names = ns.map(&:title).uniq
    names.map do |name|
      VirtualNode.new(title: name, parent_path: path)
    end
  end

  def remote_constituents
    # @remote_constituents ||=
    (
      base = parent.bridges # + parent.symbolic_overlays.select(&:remote?)
      base += parent.remote_constituents if parent.is_a?(VirtualFolder)
      base.flat_map(&:children).select do |constituent|
        constituent.title == title
      end
    )
  end

  def remote_children
    rkids = remote_constituents.flat_map(&:children) #.map(&:name)
    names = rkids.map(&:title).uniq

    names.map do |remote_child_name|
      VirtualFolder.new(title: remote_child_name, parent_path: self.path, remote: true)
    end
  end

  def remote_nodes
    rnodes = remote_constituents.flat_map(&:nodes)
    names = rnodes.map(&:title).uniq

    names.map do |remote_node_name|
      VirtualNode.new(title: remote_node_name, parent_path: self.path, remote: true)
    end
  end

  def symbolic_constituents
    (
      base = parent.symbolic_overlays
      base += parent.symbolic_constituents if parent.is_a?(VirtualFolder)
      (base.flat_map(&:children) + base.flat_map(&:virtual_children) + base.flat_map(&:remote_children)).select do |constituent|
        constituent.title == title
      end
    )
  end

  def symbolic_children
    symbolic_constituents.flat_map(&:children) +
      symbolic_constituents.flat_map(&:virtual_children) +
      symbolic_constituents.flat_map(&:remote_children) +
      symbolic_constituents.flat_map(&:symbolic_children)
  end

  def symbolic_nodes
    symbolic_constituents.flat_map(&:nodes) +
      symbolic_constituents.flat_map(&:virtual_nodes) +
      symbolic_constituents.flat_map(&:remote_nodes) +
      symbolic_constituents.flat_map(&:symbolic_nodes)
  end

  def overlays
    constituents.flat_map(&:overlays).uniq(&:path)
  end

  def symbolic_overlays
    constituents.flat_map(&:symbolic_overlays).uniq(&:path)
  end

  def tags
    constituents.flat_map(&:tags)
  end

  def path
    parent_path + title + '/'
  end

  def attributes
    { title: title, parent_path: parent_path }
  end

  def empty?
    !(virtual_nodes.any? || virtual_children.any? || symbolic_nodes.any? || symbolic_children.any?)
  end

  def descendants(depth=4)
    if depth < 0
      []
    else
      (virtual_nodes) + (virtual_children.flat_map { |vchild| vchild.descendants(depth-1) })
    end
  end

  def themed?
    parent.themed?
  end

  def active_theme
    parent.active_theme
  end

  def theme_root
    parent.theme_root
  end

  def bridges
    []
  end

  # now all 'virtualized'...
  def nodes
    []
  end

  def children
    []
  end
end
