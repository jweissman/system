class Folder < ApplicationRecord
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :children, class_name: 'Folder', foreign_key: 'parent_id'

  has_many :nodes

  def tags
    # todo scan all nodes, even contained in children
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
end
