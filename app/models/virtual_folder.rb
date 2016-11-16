# a folder present because of a mount
# there is no distinct database record for it but it needs to be logically distinct and reachable from a path
class VirtualFolder
  include ActiveModel::Model
  include ActiveModel::Serialization
  # extend ActiveModel::Naming

  attr_reader :title, :parent_path

  def initialize(title:, parent_path:,remote:false)
    @title = title
    @parent_path = parent_path
    @remote = remote
  end

  def parent
    Path.dereference(@parent_path)
  end

  def user
    # constituents.first.user
    parent.user
  end

  def constituents
    # @constituents ||=
    (
      base = parent.overlays
      base += parent.constituents if parent.is_a?(VirtualFolder)
      base.flat_map(&:children).select do |constituent|
        constituent.title == title
      end
    )
  end

  def virtual_children
    kids = constituents.flat_map(&:children) + constituents.flat_map(&:virtual_children)
    vchildren_names = kids.map(&:title).uniq
    vchildren_names.map do |name|
      VirtualFolder.new(title: name, parent_path: path)
    end
  end

  def virtual_nodes
    ns = constituents.flat_map(&:nodes) + constituents.flat_map(&:virtual_nodes)
    names = ns.map(&:title).uniq
    names.map do |name|
      VirtualNode.new(title: name, parent_path: path)
    end
  end

  def remote_constituents
    @remote_constituents ||= (
      base = parent.bridges
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

  def overlays
    constituents.flat_map(&:overlays).uniq(&:path)
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
    !(virtual_nodes.any? || virtual_children.any?)
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
