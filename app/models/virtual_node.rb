class VirtualNode
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_reader :title, :parent_path

  def initialize(title:, parent_path:)
    @title = title
    @parent_path = parent_path
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
    @constituents ||= (
      base = folder.overlays
      base += folder.constituents if folder.is_a?(VirtualFolder)
      base.flat_map(&:nodes).select do |constituent|
        constituent.title == title
      end
    )
  end

  def tags
    constituents.flat_map(&:tags).uniq
  end

  # def exemplar
  #   constituents.first
  # end

  # def content
  #   exemplar.content
  # end

  # def tags
  #   exemplar.tags
  # end

  # def created_at
  #   exemplar.created_at
  # end

  # def updated_at
  #   exemplar.updated_at
  # end

  # def user
  #   exemplar.user
  # end
end
