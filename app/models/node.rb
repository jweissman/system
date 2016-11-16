class Node < ApplicationRecord
  belongs_to :folder

  TAG_REGEX = /#([\S]+)/

  def user
    folder.user
  end

  def path
    folder.path + title
  end

  def tags
    return [] unless content =~ TAG_REGEX
    content.scan(TAG_REGEX).reduce(&:+)
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

  def empty?
    content.empty?
  end
end
