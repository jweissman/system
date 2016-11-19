class VirtualNode
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_reader :title, :parent_path

  def initialize(title:, parent_path:, remote: false, symbolic: false)
    @title = title
    @parent_path = parent_path
    @remote = remote
    @symbolic = symbolic
  end

  def remote?
    !!@remote
  end

  def path
    parent_path + title
  end

  def attributes
    { title: title, parent_path: parent_path }
  end

  def folder
    Path.dereference parent_path
  end

  def constituents
    # @constituents ||=
      (
      base = folder.overlays # + folder.symbolic_overlays.reject(&:remote?)
      base += folder.constituents if folder.is_a?(VirtualFolder)
      base.flat_map(&:nodes).select do |constituent|
        constituent.title == title
      end
    )
  end

  def remote_constituents
    # @remote_constituents ||= (
    (
      base = folder.bridges # + folder.symbolic_overlays.select(&:remote?) #flat_map(&:bridges)
      base += folder.remote_constituents if folder.is_a?(VirtualFolder)
      base.flat_map(&:nodes).select do |rc|
        rc.title == title
      end
    )
  end

  def symbolic_constituents
    (
      base = folder.symbolic_overlays
      base += folder.symbolic_constituents if folder.is_a?(VirtualFolder)
      (base.flat_map(&:nodes) + base.flat_map(&:virtual_nodes) + base.flat_map(&:remote_nodes)).select do |constituent|
        constituent.title == title
      end
    )
  end

  def tags
    constituents.flat_map(&:tags).uniq
  end

  def exemplar
    (constituents + remote_constituents + symbolic_constituents).first
  end

  def content
    exemplar.content
  end

  def tags
    exemplar.tags
  end

  def created_at
    exemplar.created_at
  end

  def updated_at
    exemplar.updated_at
  end

  def user
    exemplar.user
  end

  def parent
    folder
  end

  def children; [] end
  def virtual_children; [] end
  def nodes; [] end
  def virtual_nodes; [] end
  def remote_children; [] end
  def remote_nodes; [] end
  def symbolic_children; [] end
  def symbolic_nodes; [] end

  def empty?
    content.empty?
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
end
