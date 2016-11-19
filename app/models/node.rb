class Node < ApplicationRecord
  belongs_to :folder
  has_one :user, through: :folder

  def path
    folder.path + title
  end

  def tags
    Tag.match(content)
  end

  def parent
    folder
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

  def children; [] end
  def nodes; [] end
  def virtual_children; [] end
  def virtual_nodes; [] end
  def remote_children; [] end
  def remote_nodes; [] end
  def symbolic_children; [] end
  def symbolic_nodes; [] end

  def empty?
    content.empty?
  end
end
